Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20191117154349.28695-1-amir73il@gmail.com> <20191117154349.28695-5-amir73il@gmail.com>
In-Reply-To: <20191117154349.28695-5-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 18 Nov 2019 19:01:48 +0200
Message-ID: <CAOQ4uxioVp0ULGz6fXLyC9rBeNdV4nT0swzVpY2yKgSuThPo0Q@mail.gmail.com>
Subject: Re: [PATCH 4/6] ovl: generalize the lower_fs[] array
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Colin Ian King <colin.king@canonical.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Nov 17, 2019 at 5:44 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Rename lower_fs[] array to fs[], extend its size by one and initialize
> fs[0] with upper fs values. fsid 0 is already reserved even with lower
> only overlay, so fs[0] remains uninitialized in this case as well.
>
> Rename numlowerfs to maxfsid and use index 0..maxfsid to access the
> fs[] array.
>

FYI, I don't know what I was thinking with the conversion to maxfsid.
I don't like that and intend to change it back to numfs.

Thanks,
Amir.
