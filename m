From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH][V3] overlayfs: During copy up, first copy up data and
 then xattrs
Date: Tue, 15 Jan 2019 10:26:12 +0100
Message-ID: <CAJfpegvNQmG4=5i_Q7uMzFa_-UDMXr4JL-2rP=a3F+9sPvbs1g@mail.gmail.com>
References: <20190111183743.GC16012@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190111183743.GC16012@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, stable <stable@vger.kernel.org>, Daniel J Walsh <dwalsh@redhat.com>, gscrivan@redhat.com
List-Id: linux-unionfs@vger.kernel.org

On Fri, Jan 11, 2019 at 7:37 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> If a file with capability set (and hence security.capability xattr) is
> written kernel clears security.capability xattr. For overlay, during file
> copy up if xattrs are copied up first and then data is, copied up. This
> means data copy up will result in clearing of security.capability xattr
> file on lower has. And this can result into surprises. If
> a lower file has CAP_SETUID, then it should not be cleared over
> copy up (if nothing was actually written to file).
>
> This also creates problems with chown logic where it first copies up file
> and then tries to clear setuid bit. But by that time security.capability
> xattr is already gone (due to data copy up), and caller gets -ENODATA.
> This has been reported by Giuseppe here.
>
> https://github.com/containers/libpod/issues/2015#issuecomment-447824842
>
> Fix this by copying up data first and then metadta. This is a regression
> which has been introduced by my commit as part of metadata only copy up
> patches.
>
> TODO: There will be some corner cases where a file is copied up metadata
>       only and later data copy up happens and that will clear
>       security.capability xattr. Something needs to be done about that too.
>
> Fixes: bd64e57586d3 ("ovl: During copy up, first copy up metadata and then data")
> Cc: <stable@vger.kernel.org> # v4.19+
> Reported-by: Giuseppe Scrivano <gscrivan@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Thanks, applied.

Miklos
