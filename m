MIME-Version: 1.0
In-Reply-To: <20180510153232.GA7651@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
	<20180507174102.24086-11-vgoyal@redhat.com>
	<CAJfpegvzDAMx66TMhHTacYEUpowRcEYKkFuhD+TQoV83MfXPmQ@mail.gmail.com>
	<CAJfpegtizFNe3tm7reYMYGBsmD-dzZTHNsSGrb5BZ_gaeu2Sfw@mail.gmail.com>
	<20180510153232.GA7651@redhat.com>
Date: Thu, 10 May 2018 22:21:17 +0200
Message-ID: <CAJfpegv-5m79y6wwWev2dPMCO96dCAz9+_8vLhXn=20xVE6b7A@mail.gmail.com>
Subject: Re: [PATCH v15 10/30] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, May 10, 2018 at 5:32 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, May 10, 2018 at 11:36:16AM +0200, Miklos Szeredi wrote:
> [..]
>> > We also need to check file type here, only regular file makes sense as
>> > metacopy, so if it's something else, then get out with EIO.
>>
>> I meant file type of *data* inode.  Type of metacopy inode is already
>> checked by ovl_check_metacopy_xattr().
>
> Hi Miklos,
>
> IIUC, ovl_lookup_single() will make sure we don't return directory dentry
> for a metacopy upper (After your suggested changes).
>
>         if (last_element) {
>                 if (d->metacopy) {
>                         d->stop = true;
>                         goto put_and_out;
>                 }
>                 d->is_dir = true;
>         }
>
> If that's the case, then we probably don't need additional check in
> ovl_lookup().

It should check d_is_reg() explicitly.  Being non-dir doesn't mean
it's a regular file.

Thanks,
Miklos
