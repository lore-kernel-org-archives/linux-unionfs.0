Return-Path: <vgoyal@redhat.com>
Date: Thu, 10 May 2018 11:32:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v15 10/30] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
Message-ID: <20180510153232.GA7651@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
 <20180507174102.24086-11-vgoyal@redhat.com>
 <CAJfpegvzDAMx66TMhHTacYEUpowRcEYKkFuhD+TQoV83MfXPmQ@mail.gmail.com>
 <CAJfpegtizFNe3tm7reYMYGBsmD-dzZTHNsSGrb5BZ_gaeu2Sfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegtizFNe3tm7reYMYGBsmD-dzZTHNsSGrb5BZ_gaeu2Sfw@mail.gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, May 10, 2018 at 11:36:16AM +0200, Miklos Szeredi wrote:
[..]
> > We also need to check file type here, only regular file makes sense as
> > metacopy, so if it's something else, then get out with EIO.
> 
> I meant file type of *data* inode.  Type of metacopy inode is already
> checked by ovl_check_metacopy_xattr().

Hi Miklos,

IIUC, ovl_lookup_single() will make sure we don't return directory dentry
for a metacopy upper (After your suggested changes).

        if (last_element) {
                if (d->metacopy) {
                        d->stop = true;
                        goto put_and_out;
                }
                d->is_dir = true;
        }

If that's the case, then we probably don't need additional check in
ovl_lookup().

Thanks
Vivek
