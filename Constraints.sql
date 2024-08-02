ALTER TABLE public.accesses ADD CONSTRAINT accesses_ref_username FOREIGN KEY (username) REFERENCES public.users (email) ON DELETE CASCADE;
ALTER TABLE public.portfolios ADD CONSTRAINT portfolio_ref_username FOREIGN KEY (username) REFERENCES public.users (email) ON DELETE CASCADE;
ALTER TABLE public.stocklists ADD CONSTRAINT stocklist_ref_username FOREIGN KEY (username) REFERENCES public.users (email) ON DELETE CASCADE;
ALTER TABLE public.friends ADD CONSTRAINT friend_ref_user_from FOREIGN KEY (user_from) REFERENCES public.users (email) ON DELETE CASCADE;
ALTER TABLE public.friends ADD CONSTRAINT friend_ref_user_to FOREIGN KEY (user_to) REFERENCES public.users (email) ON DELETE CASCADE;
ALTER TABLE public.reviews ADD CONSTRAINT username FOREIGN KEY (username) REFERENCES public.users (email) ON DELETE CASCADE;

