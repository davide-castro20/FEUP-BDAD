-- When a user views a video, the number_of_likes of that video is update according to the reaction of the user.
-- Also, if the video is monetized, the revenue of the video is updated according to the payment of the ads which played during the time the user viewed the video.
 

CREATE TRIGGER ViewVideoTrigger
AFTER INSERT ON ViewVideo
FOR EACH ROW 
BEGIN
    UPDATE Video
    SET number_of_likes = number_of_likes + New.reaction
    WHERE New.IDvideo = Video.ID;

    UPDATE MonetizedVideo
    SET total_payment = total_payment + 
    (SELECT sum(payment) 
    FROM Ad INNER JOIN 
        (SELECT IDad
        FROM PlayingAd
        WHERE IDmonetizedVideo = New.IDvideo AND PlayingAd.time < '5:00' ) AS AdsPlayed 
    ON (Ad.ID = AdsPlayed.IDad) )
    WHERE (New.IDuser IN (SELECT ID FROM User WHERE monthly_subscription = 0)) and (New.IDvideo = MonetizedVideo.ID);
END;
