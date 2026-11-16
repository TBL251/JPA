package vn.iotstar.dao;

import java.util.List;
import vn.iotstar.entity.Video;

public interface IVideoDao {
    int count();
    List<Video> findAll();
    List<Video> findAll(int page, int pageSize);
    Video findById(String videoId);
    void insert(Video video);
    void update(Video video);
    void delete(String videoId) throws Exception;
    List<Video> findTop10Latest();
    List<Video> findByUserId(int userId, int page, int pageSize);
    int countByUserId(int userId);
    void increaseViews(String videoId);
}
