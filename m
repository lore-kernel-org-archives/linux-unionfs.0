Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1523932965-25792-2-git-send-email-cgxu519@gmx.com>
References: <1523932965-25792-1-git-send-email-cgxu519@gmx.com> <1523932965-25792-2-git-send-email-cgxu519@gmx.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 17 Apr 2018 14:16:24 +0300
Message-ID: <CAOQ4uxjdjZYUw_6Y6AqWpR+Rb_9iinsTxKzm39yjpWpiwhLvOQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] ovl: using lowestack handling functions to replace
 bare array operation
Content-Type: text/plain; charset="UTF-8"
To: Chengguang Xu <cgxu519@gmx.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Apr 17, 2018 at 5:42 AM, Chengguang Xu <cgxu519@gmx.com> wrote:
> ovl_*_lower() can handle lowerstack requirement well and more importantly
> we can hide detail lowerstack implementation for outside. so using these
> functions to replace bare array operaion.
>

In not using bare array operation a worthy goal??
If you follow my suggestion in patch 3/3, you will be able to avoid this goal
and keep using array operations instead of __ovl_path_lower().

Thanks,
Amir.
