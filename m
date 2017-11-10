From: Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: [PATCH] ovl: fix null pointer dereference on ofs allocation failure.
Date: Fri, 10 Nov 2017 09:54:48 +0100
Message-ID: <CAOssrKfZ3Bt4n87JOh=N-3X3XY8J1aBL7rFNG9u2efk41nAqiA@mail.gmail.com>
References: <20171109174751.11683-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171109174751.11683-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, kernel-janitors@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Nov 9, 2017 at 6:47 PM, Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> The current error exit path when ofs fails to allocate jumps
> to clean-up code that calls ovl_free_fs resulting in a null pointer
> dereference on the null ovl pointer.  Fix this by simply returning
> with the -ENOMEM status in err.
>
> Detected by CoverityScan, CID#1461284 ("Dereference after null check")


Thanks, fixed.

Miklos
