Return-Path: <vgoyal@redhat.com>
Date: Fri, 11 May 2018 08:28:37 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v15 10/30] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
Message-ID: <20180511122837.GA6044@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
 <20180507174102.24086-11-vgoyal@redhat.com>
 <CAJfpegvzDAMx66TMhHTacYEUpowRcEYKkFuhD+TQoV83MfXPmQ@mail.gmail.com>
 <20180510193913.GA11152@redhat.com>
 <CAJfpeguVb-u2Tzrz2f1L3bgE8QS+cwhCpBsfW3=+J8s-jZerBw@mail.gmail.com>
 <CAJfpegtOADQ_gpLxrMRWoXqf8Q3Fe9FyF=Q8pQit0F656=c3ug@mail.gmail.com>
 <CAOQ4uxi_1HKSAbbmMdAFMLLZprN0uh=qXSa00eq1Grtt+68Q6Q@mail.gmail.com>
 <CAJfpegsPiXUgsMRjsQNT-puki_qmJ90g0datdXFEbSK0FNFg1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegsPiXUgsMRjsQNT-puki_qmJ90g0datdXFEbSK0FNFg1g@mail.gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, May 11, 2018 at 10:13:34AM +0200, Miklos Szeredi wrote:

[..]
> > I am not saying this is not solvable, just that it is more complex
> > than the table above and I wouldn't want Vivek to have to untangle
> > all this mess with current patch series.
> >
> > So for compromise, I suggest to follow Vivek's suggestion to
> > enforce next_layer == origin_fh if index=on,metacopy=on.
> >
> > This does not break the copied layer use case, because with
> > copied layers, lower layer origin_fh verification on mount will
> > fail and won't allow to set index=on.
> >
> > This is similar to the compromise that we have made with
> > nfs_export so we won't need to deal with ovl_fh generations
> > when index name does not match origin fh.
> 
> Okay, lets do that for now.

Cool. let me modify the patch.

Thanks
Vivek
