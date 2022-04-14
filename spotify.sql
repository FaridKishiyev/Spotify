CREATE DATABASE Spotify

USE Spotify
CREATE TABLE Musics
(
	Id int PRIMARY KEY IDENTITY,
	[Name] nvarchar(255),
	TotalSecond int,
	ListenerCount int
)

CREATE TABLE Artists
(
	Id int PRIMARY KEY IDENTITY,
	[Name] nvarchar(255)
)

CREATE TABLE Albums
(
	Id int PRIMARY KEY IDENTITY,
	[Name] nvarchar(255),

)

CREATE TABLE MucicAlbums
(
	Id int PRIMARY KEY IDENTITY,
	AlbumsId int REFERENCES Albums(id),
	MusicId int REFERENCES Musics(id)
)

CREATE TABLE MusicArtist
(
	Id int PRIMARY KEY IDENTITY,
	ArtisId int REFERENCES Artists(id),
	MusicId int REFERENCES Musics(id)
)

CREATE TABLE Spotify
(
	Id int PRIMARY KEY IDENTITY,
	MusicId int REFERENCES Musics(id),
	AlbumId int REFERENCES Albums(id),
	ArtisId int REFERENCES Artists(id),
)

CREATE VIEW V_Spotify
AS SELECT Musics.Name AS Music, Musics.TotalSecond, Artists.Name AS Artis, Albums.Name AS Album 
FROM Spotify 
JOIN Musics ON Spotify.MusicId = Musics.Id
JOIN Artists ON Spotify.ArtisId = Artists.Id
JOIN Albums ON Spotify.AlbumId = Albums.Id

SELECT * FROM V_Spotify

CREATE VIEW V_Album
AS SELECT  Albums.Name, COUNT(MucicAlbums.AlbumsId) AS MusicCount
FROM MucicAlbums
JOIN Albums ON Albums.Id = MucicAlbums.AlbumsId
GROUP BY Albums.Name

SELECT * FROM V_Album

CREATE PROCEDURE SelectMusic @ListenerCount int,@search nvarchar(255)
AS
SELECT Albums.Name,Musics.Name,Musics.ListenerCount 
FROM Spotify 
JOIN Musics ON Spotify.MusicId = Musics.Id
JOIN Albums ON Spotify.AlbumId = Albums.Id
WHERE @ListenerCount > Musics.ListenerCount AND Albums.Name Like '@search'
GO;

EXEC SelectMusic @ListenerCount=50, @search = 'a'