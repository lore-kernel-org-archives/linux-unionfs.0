From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH][V2] ovl: fix lookup failure on multi lower squashfs
Date: Thu, 14 Nov 2019 16:34:42 +0100
Message-ID: <CAJfpegvKnWR6_aPFwjcP8E7CRPesHPc3Svk=n9=39CnM=Mjfvg@mail.gmail.com>
References: <20191107104957.306383-1-colin.king@canonical.com>
 <CAJfpegtr_xg_VG2npTfaxC+vD7B8bKa_0n9pu5vyfU-XQ9oV9Q@mail.gmail.com>
 <CAOQ4uxhnpeyK6xW-c5NOQZ_h1uhAOUn_BbVVVYhUgZ74KSKDKQ@mail.gmail.com>
 <CAJfpegu7egxf=BVyVQKKW_icjMbjdLcLdd1FEw5hXLvDaiLNVQ@mail.gmail.com> <CAOQ4uxh8n-QW+zTe3Y56suyaQf8Tcascj337AbMmKF7jf9=sjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxh8n-QW+zTe3Y56suyaQf8Tcascj337AbMmKF7jf9=sjw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Colin King <colin.king@canonical.com>, Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, stable <stable@vger.kernel.org>, kernel-janitors@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Nov 14, 2019 at 3:37 PM Amir Goldstein <amir73il@gmail.com> wrote:

> What Colin has now reported brings to light the fact that
> decoding lower file handles was also required for making inode
> numbers persistent.
>
> So the bad_uuid condition is required for all of the above, not
> just for decoding origin.
>
> > Can we do a message that makes
> > that somewhat more clearer?
> >
>
> What about the logs:
>
>                 pr_warn("overlayfs: upper fs does not support xattr,
> falling back to index=off and metacopy=off.\n");
>                 pr_warn("overlayfs: upper fs does not support file
> handles, falling back to index=off.\n");
>                 pr_warn("overlayfs: fs on '%s' does not support file
> handles, falling back to index=off,nfs_export=off.\n",
>
> Should we also change them to reflect the fact the decoding origin
> is not supported???
>
> Seems like a lot of hassle that will end up writing too much information
> that most people won't understand.
>
> IIRC, we also do not guaranty persistent inode numbers for hardlinks
> when index=off.
>
> As for the change in question (falling back => enforcing), if that bothers you,
> we can get rid of this change by testing emitting the print only if
> (ofs->config.nfs_export || ofs->config.index).

That makes sense.

It would also make sense to have a section about inode number
persistence in the documentation.

Thanks,
Miklos
