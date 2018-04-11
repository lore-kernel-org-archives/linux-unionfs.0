MIME-Version: 1.0
In-Reply-To: <CAOQ4uxjsaK0pkxHNLYe=kMwTCmA+gcH5dUXtM0EV0RjPawCbvA@mail.gmail.com>
References: <779D1CE1-7805-4026-BC7D-3773D5E37B34@gmx.com>
	<CAOQ4uxjuO8ZUH_9Y68-y0JQsF9yunTarF6YFCtSW20V_EjXUFA@mail.gmail.com>
	<C665F64A-11F7-4F6F-82D4-8F287A983E30@gmx.com>
	<CAJfpegvLerH4J_zzXCMHOhbuwJT5-NYZiY91Dnc1GAUyKTu8zA@mail.gmail.com>
	<CAOQ4uxjsaK0pkxHNLYe=kMwTCmA+gcH5dUXtM0EV0RjPawCbvA@mail.gmail.com>
Date: Wed, 11 Apr 2018 11:04:10 +0200
Message-ID: <CAJfpegtRmBkpJK-qNnmrWXSaX1EorjBfix9Qmu_Ha4=9HSnRQw@mail.gmail.com>
Subject: Re: question of copying stack in ovl_lookup()
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: "cgxu519@gmx.com" <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Apr 11, 2018 at 10:35 AM, Amir Goldstein <amir73il@gmail.com> wrote:

> We could pack the ovl_entry further to 32 bytes with or without cache
> pool. Not sure if it is worse it though(?):
>
> struct ovl_path {
>         unsigned short reserved;
>         unsigned short layer_idx;
>         struct dentry *dentry;
> };
>
> struct ovl_entry {
>         union {
>                 struct {
>                         unsigned long flags;

Heh, this anonymous struct is no longer needed.

>                 };
>                 struct rcu_head rcu;

Not sure what are we protecting in overlay_entry with rcu.  A comment
somewhere would be good.  Will need to investigate...

>         };
>         union {
>                 unsigned short numlower;
>                 struct ovl_path lowerstack[1];
>         };
> };

Ugly.

Thanks,
Miklos
