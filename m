MIME-Version: 1.0
Date: Tue, 11 Jun 2019 15:58:37 +0200
References: <20190609160344.24979-1-amir73il@gmail.com>
In-Reply-To: <20190609160344.24979-1-amir73il@gmail.com>
Message-ID: <CAJfpegt4QXGC0-y_sug7kuFo2q28c6DFJQnQ-UHe1bmCGC0jag@mail.gmail.com>
Subject: Re: [PATCH] ovl: make i_ino consistent with st_ino in more cases
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Jun 9, 2019 at 6:03 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Relax the condition that overlayfs supports nfs export, to require
> that i_ino is consistent with st_ino/d_ino.
>
> It is enough to require that st_ino and d_ino are consistent.

Yes.

>
> This fixes the failure of xfstest generic/504, due to mismatch of
> st_ino to inode number in the output of /proc/locks.
>
> Fixes: 12574a9f4c9c ("ovl: consistent i_ino for non-samefs with xino")
> Cc: <stable@vger.kernel.org> # v4.19
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Miklos,
>
> TBH, I can't remember why I put the s_export_op condition in the
> first place (can you?), expect for the fact the original bug fix
> was reported on nfsd readdirplus.

I have no recollection of any issue that would require nfs export.

I've applied the patch.

Thanks,
Miklos
