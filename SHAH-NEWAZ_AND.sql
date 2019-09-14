USE [Test]
GO

/****** Object:  StoredProcedure [dbo].[SPGETProductWithAND]    Script Date: 13-Sep-19 12:14:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SPGETProductWithAND]
  @PageNumber int,
  @PageSize int,
  @OrderBy nvarchar(100),
  @Id int = NULL,
  @Name nvarchar(50) = NULL,
  @Price money = NULL,
  @Description nvarchar(MAX) = NULL,
  @ImageUrl nvarchar(100) = NULL,
  @Category nvarchar(150) = NULL,
  @Rating int = NULL,
  @Weight int = NULL,
  @IsActive bit = 0,
  @Width int = NULL,
  @Height int = NULL
 -- @debug bit = 0

AS

DECLARE @sql        nvarchar(MAX), 
        @paramlist  nvarchar(4000),
        @nl         char(2) = char(13) + char(10)

SELECT @sql = 'SELECT * from Product WHERE  1 = 1' + @nl


IF @Id IS NOT NULL
   SELECT @sql += ' AND Id = @id' + @nl
IF @Name IS NOT NULL
   SELECT @sql += ' And [Name] Like @Name + ''%''' + + @nl
IF @Price IS NOT NULL
   SELECT @sql += ' AND Price = @Price'  + @nl
IF @Description IS NOT NULL
   SELECT @sql += ' AND Description = @Description'  + @nl
IF @ImageUrl IS NOT NULL
   SELECT @sql += ' AND ImageUrl = @ImageUrl'  + @nl
IF @Category IS NOT NULL
   SELECT @sql += ' AND Category = @Category'  + @nl
IF @Rating IS NOT NULL
   SELECT @sql += ' AND Rating = @Rating'  + @nl
IF @Weight IS NOT NULL
   SELECT @sql += ' AND Weight = @Weight'  + @nl
IF @IsActive IS NOT NULL
   SELECT @sql += ' AND IsActive = @IsActive'  + @nl
IF @Width IS NOT NULL
   SELECT @sql += ' AND Width = @Width'  + @nl
IF @Height IS NOT NULL
   SELECT @sql += ' AND Height = @Height'  + @nl

SELECT @sql += ' ORDER BY '+quotename(@OrderBy)+ ' OFFSET (@PageNumber-1) * @PageSize  ROWS FETCH NEXT @PageSize ROWS ONLY' + @nl

--SELECT @sql += ' ORDER BY id' + @nl
--IF @debug = 1
-- PRINT @sql


SELECT @paramlist = '@PageNumber int,
           @PageSize int,
           @OrderBy nvarchar(100),
           @Id int,
                     @Name nvarchar(50),
                     @Price money,
                     @Description nvarchar(MAX),
                     @ImageUrl nvarchar(100),
                     @Category nvarchar(50),
                     @Rating int,
                     @Weight int,
                     @IsActive bit,
                     @Width int,
                     @Height int'
--@debug bit
                   
EXEC sp_executesql @sql, @paramlist,@PageNumber, @PageSize, @OrderBy,
                   @Id, @Name, @Price, @Description,
                   @ImageUrl,  @Category, @Rating, @Weight,@IsActive,
                   @Width, @Height 
--@debug

GO

