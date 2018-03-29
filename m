MIME-Version: 1.0
In-Reply-To: <1516290977-130583-1-git-send-email-cgxu519@icloud.com>
References: <1516290977-130583-1-git-send-email-cgxu519@icloud.com>
Date: Thu, 29 Mar 2018 15:00:06 +0200
Message-ID: <CAJfpegsKGQaPhFRkTscPvhoWNkrARnkUUH8=F8JCsjOa7eTR9A@mail.gmail.com>
Subject: Re: [PATCH] ovl: Using slab allocation for frequently used struct
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Jan 18, 2018 at 4:56 PM, Chengguang Xu <cgxu519@icloud.com> wrote:
> Introducing slab allocation to replace kmalloc/kfree for
> frequently used struct ovl_dir_file and ovl_dir_cache.

The thing is: ovl_cache_entry has much higher usage than ovl_dir_file
or ovl_dir_cache.  So if we want to optimize, ovl_cache_entry should
be the starting point.  This patch just adds extra code without a
clear understading about why that code is needed.

Thanks,
Miklos
