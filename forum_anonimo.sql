create function anonymize() returns trigger as $command$
	begin
    	if NEW.forum_id = 134 or NEW.forum_id = 133 then

        if (TG_OP = 'UPDATE') THEN
            NEW.topic_poster := 1;
            NEW.topic_first_poster_name := 'Anónimo';
            NEW.topic_last_poster_id := 1;
            NEW.topic_last_poster_name := 'Anónimo';
            NEW.topic_bumper := 0;
            NEW.topic_first_poster_colour := '';
            NEW.topic_last_poster_colour := '';
            OLD.topic_last_poster_colour := '';
        ELSIF (TG_OP = 'INSERT') THEN
            NEW.topic_poster := 1;
            NEW.topic_first_poster_name := 'Anónimo';
            NEW.topic_last_poster_id := 1;
            NEW.topic_last_poster_name := 'Anónimo';
            NEW.topic_bumper := 0;
            NEW.topic_first_poster_colour := '';
            NEW.topic_last_poster_colour := '';
        END IF;

        	
        end if;

        return NEW;
    end;
    
$command$ language plpgsql;

CREATE TRIGGER anonymizeTopicAuthor BEFORE INSERT OR UPDATE ON forum_topics FOR EACH ROW
    EXECUTE PROCEDURE anonymize();


create function anonymizePoster() returns trigger as $command$
	begin
    	if NEW.forum_id = 134 or NEW.forum_id = 133 then

        	NEW.poster_id := 1;
        end if;

        return NEW;
    end;
    
$command$ language plpgsql;

CREATE TRIGGER anonymizePoster BEFORE INSERT OR UPDATE ON forum_posts FOR EACH ROW
    EXECUTE PROCEDURE anonymizePoster();


create function anonymizeLastPostedBy() returns trigger as $command$
    declare
    row record;
	begin
        for row in select forum_id as forum_id from forum_posts where forum_posts.topic_id = NEW.topic_id limit 1 loop
            if row.forum_id = 133 or row.forum_id = 134 then
                NEW.user_id := 1;
                return NEW;
            end if;
        end loop;

        return NEW;
    end;
    
$command$ language plpgsql;

CREATE TRIGGER anonymizeLastPostedByTrigger BEFORE INSERT ON forum_topics_posted FOR EACH ROW
    EXECUTE PROCEDURE anonymizeLastPostedBy();


create function anonymizeLastPostedByIndexPage() returns trigger as $command$
	begin
        if NEW.forum_id = 134 or NEW.forum_id = 133 then
            OLD.forum_last_poster_id := 1;
            OLD.forum_last_poster_name := 'Anónimo';
            OLD.forum_last_poster_colour := '';
            NEW.forum_last_poster_id := 1;
            NEW.forum_last_poster_name := 'Anónimo';
            NEW.forum_last_poster_colour := '';
        end if;

        return NEW;
    end;
    
$command$ language plpgsql;

CREATE TRIGGER anonymizeLastPostedByIndexPageTrigger BEFORE UPDATE ON forum_forums FOR EACH ROW
    EXECUTE PROCEDURE anonymizeLastPostedByIndexPage();



create function disableObserveSecretTopics() returns trigger as $command$
	begin
        if NEW.forum_id = 134 or NEW.forum_id = 133 then
            return null;
        end if;

        return NEW;
    end;
    
$command$ language plpgsql;

CREATE TRIGGER disableObserveSecretTopicsTrigger BEFORE INSERT ON forum_forums_track FOR EACH ROW
    EXECUTE PROCEDURE disableObserveSecretTopics();


create function disableSubscribeSecretTopics() returns trigger as $command$
	begin
        if NEW.forum_id = 134 or NEW.forum_id = 133 then
            return null;
        end if;

        return NEW;
    end;
    
$command$ language plpgsql;

CREATE TRIGGER disableSubscribeTopicsTrigger BEFORE INSERT ON forum_topics_track FOR EACH ROW
    EXECUTE PROCEDURE disableSubscribeSecretTopics();


create function disableWatchSecretPosts() returns trigger as $command$
    declare
    row record;
	begin
        for row in select forum_id as forum_id from forum_posts where forum_posts.topic_id = NEW.topic_id limit 1 loop
            if row.forum_id = 133 or row.forum_id = 134 then
                return null;
            end if;
        end loop;

        return NEW;
    end;
    
$command$ language plpgsql;

CREATE TRIGGER disableWatchSecretPostsTrigger BEFORE INSERT ON forum_topics_watch FOR EACH ROW
    EXECUTE PROCEDURE disableWatchSecretPosts();
