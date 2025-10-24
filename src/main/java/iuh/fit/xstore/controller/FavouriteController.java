package iuh.fit.xstore.controller;

import iuh.fit.xstore.dto.request.FavouriteRequest;
import iuh.fit.xstore.model.Favourite;
import iuh.fit.xstore.model.FavouriteID;
import iuh.fit.xstore.service.FavouriteService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/favourites")
@RequiredArgsConstructor
public class FavouriteController {

    private final FavouriteService favouriteService;

    @GetMapping
    public ResponseEntity<List<Favourite>> getAll() {
        return ResponseEntity.ok(favouriteService.findAll());
    }

    @PostMapping
    public ResponseEntity<Favourite> create(@RequestBody FavouriteRequest request) {
        Favourite fav = favouriteService.createFavourite(request);
        return ResponseEntity.ok(fav);
    }

    @DeleteMapping("/{userId}/{productId}")
    public ResponseEntity<FavouriteID> delete(@PathVariable int userId, @PathVariable int productId) {
        FavouriteID deleted = favouriteService.deleteFavourite(userId, productId);
        return ResponseEntity.ok(deleted);
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Favourite>> findByUser(@PathVariable int userId) {
        return ResponseEntity.ok(favouriteService.findByUserId(userId));
    }
}
