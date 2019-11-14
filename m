From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH][V4] ovl: fix lookup failure on multi lower squashfs
Date: Thu, 14 Nov 2019 11:30:14 +0100
Message-ID: <CAJfpegug-saOEigqDNKfwMR5qdzrbLnRBD=0eN5juGioFH_L_Q@mail.gmail.com>
References: <20191113200651.114606-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191113200651.114606-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, Nov 13, 2019 at 9:06 PM Colin King <colin.king@canonical.com> wrote:
>
> From: Amir Goldstein <amir73il@gmail.com>
>
> In the past, overlayfs required that lower fs have non null
> uuid in order to support nfs export and decode copy up origin file handles.
>
> Commit 9df085f3c9a2 ("ovl: relax requirement for non null uuid of
> lower fs") relaxed this requirement for nfs export support, as long
> as uuid (even if null) is unique among all lower fs.

I see another corner case:

n- two filesystems, A and B, both have null uuid
 - upper layer is on A
 - lower layer 1 is also on A
 - lower layer 2 is on B

In this case bad_uuid won't be set for B, because the check only
involves the list of lower fs.  Hence we'll try to decode a layer 2
origin on layer 1 and fail.

Can we fix this without special casing lower layer fsid == 0 in
various places?  I guess that involves using lower_fs[0] for the
fsid=0 case (i.e. index lower_fs by fsid, rather than (fsid -1)).
Probably warrants a separate patch.

Thanks,
Miklos
