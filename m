Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180426191013.13219-19-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com> <20180426191013.13219-19-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 28 Apr 2018 00:34:29 -0700
Message-ID: <CAOQ4uxj6PyqSVJ=te_jVYxYKx3DaQXLgUD9wx-xts9rjWzq3=A@mail.gmail.com>
Subject: Re: [PATCH v14 18/31] ovl: Move some dir related ovl_lookup_single()
 code in else block
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Apr 26, 2018 at 12:10 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Move some directory related code in else block. This is pure code
> reorganization and no functionality change.
>
> Next patch enables redirect processing on metacopy files and needs this
> change.  By keeping non-functional changes in a separate patch, next patch
> looks much smaller and cleaner.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
