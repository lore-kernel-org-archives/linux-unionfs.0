Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20191117154349.28695-1-amir73il@gmail.com>
In-Reply-To: <20191117154349.28695-1-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 18 Nov 2019 08:03:00 +0200
Message-ID: <CAOQ4uxjMbNVf9-1YjUpDzyaM_aV7OD0hi4m_AMbUvH3vUVn4sQ@mail.gmail.com>
Subject: Re: [PATCH 0/6] Sort out overlay layers and fs arrays
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Colin Ian King <colin.king@canonical.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Nov 17, 2019 at 5:43 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Miklos,
>
> When I started generalizing the lower_layers/lower_fs arrays
> I noticed a bug that was introduced in v4.17 with xino.
>
> In the case of lower layer on upper fs, we do not have a pseudo_dev
> assigned to lower layer and we expose the real lower st_dev;st_ino.
> This happens on non-samefs when xino is disabled (default).
> This is a very real bug, not really a corner case and I have an
> an xfstest [1] for it that I will post later.
>
> In the mean while, I also pushed a fix to unionmount-testsuite devel
> branch [2] to demonstrate the issue.
>
> With upstream kernel, this test ends up with a copied up file
> from middle layer, whose on same fs as upper and its exposed
> st_dev;st_ino are invalid:
>
>  ./run --ov=1 --verify hard-link
>  ...
>  /mnt/a/no_foo110: File unexpectedly on upper layer
>
> Patch 1 in the series is a small fix for stable that fixes the
> v4.17 regression in favor of a different, less severe regression.
> The new regression can be demonstrated with:
>
>  ./run --ov=1 --verify --xino hard-link
>  ...
>  /mnt/a/no_foo110: inode number/layer changed on copy up
>  (got 39:24707, was 39:24700)
>
> Patches 2-4 generalize the lower_{layer/fs} arrays to layer/fs arrays
> and get rid of some special casing of upper layer.
>
> Patches 5-6 use the cleanup to solve the corner case that you pointed
> out with bas_uuid [3] and to fix the regression introduced by patch 1.
>
> After patch 6, both unionmount-testsuite configurations
> above pass the test st_dev;st_ino verifications.
>
> I doubt if patches 2-6 are stable material, because not sure the
> corner cases they fix are worth the trouble.
>
> The series depends on the bad_uuid patch v5 that I posted on Thursday.
>
> I was also considering setting xino=on by default if xino_auto
> is enabled, because what have we got to loose?
>
> The inodes whose st_ino fit in lower bits (by far more common) will
> use overlay st_dev and the inodes whose st_ino overflow the lower bits
> will use pseudo_dev. Seems like a win-win situation, but I wanted to
> get your feedback on this before sending out a patch.
>

Arrr.. yes, there is a catch.
Overflowing lower bits has a price beyond just using pseudo_dev.
It introduces the possibility of inode number conflicts on directories,
because directories never use pseudo_dev.

Thanks,
Amir.
