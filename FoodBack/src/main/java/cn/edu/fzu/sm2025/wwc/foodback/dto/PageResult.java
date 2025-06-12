package cn.edu.fzu.sm2025.wwc.foodback.dto;

import lombok.Getter;

import java.util.List;

@Getter
public class PageResult<T> {
    private long total;
    private List<T> list;

    public PageResult(long total, List<T> list) {
        this.total = total;
        this.list = list;
    }

}
