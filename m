MIME-Version: 1.0
In-Reply-To: <CAOQ4uxi_1HKSAbbmMdAFMLLZprN0uh=qXSa00eq1Grtt+68Q6Q@mail.gmail.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
	<20180507174102.24086-11-vgoyal@redhat.com>
	<CAJfpegvzDAMx66TMhHTacYEUpowRcEYKkFuhD+TQoV83MfXPmQ@mail.gmail.com>
	<20180510193913.GA11152@redhat.com>
	<CAJfpeguVb-u2Tzrz2f1L3bgE8QS+cwhCpBsfW3=+J8s-jZerBw@mail.gmail.com>
	<CAJfpegtOADQ_gpLxrMRWoXqf8Q3Fe9FyF=Q8pQit0F656=c3ug@mail.gmail.com>
	<CAOQ4uxi_1HKSAbbmMdAFMLLZprN0uh=qXSa00eq1Grtt+68Q6Q@mail.gmail.com>
Date: Fri, 11 May 2018 10:13:34 +0200
Message-ID: <CAJfpegsPiXUgsMRjsQNT-puki_qmJ90g0datdXFEbSK0FNFg1g@mail.gmail.com>
Subject: Re: [PATCH v15 10/30] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, May 11, 2018 at 9:52 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, May 11, 2018 at 10:29 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Thu, May 10, 2018 at 10:13 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>>>  - if upper has REDIRECT, then use that to determine origin (just like
>>> directories)
>>>  - else if upper has METACOPY, then go down one level to determine
>>> origin (just like directories)
>>>  - else if upper has ORIGIN, then use that as origin (not applicable
>>> to directories (*))
>>>  - else no origin (just like directories)
>>
>> Desirable way to find origin summarized in a table:
>>
>> lookup by   dir            reg       special
>> --------------------------------------------
>> redirect    REDIRECT       REDIRECT  n/a
>> next layer  default        METACOPY  n/a
>> origin fh   OPAQUE+ORIGIN  ORIGIN    ORIGIN
>> stop        OPAQUE         default   default
>>
>
> OK, but how to determine the value of indexed_by and hashed_by
> when next_layer and origin_fh do not agree?
>
> Between the lines I read that your answer is next_layer
> overrules origin_fh (as we have for directories).

Right.

>
> What I am concerned about is inconsistency of the
> form that index entry name, does not match the ORIGIN
> xattr of that index entry.
>
> First of all this will fail index verification on mount and may
> need to be fixed.
>
> I am also concerned that there are bugs lurking in the form
> of hardlink inode that can be hashed in two different ways
> depending on how is is looked up.

Hah, good point.

Basically what you are saying is that an overlay created with an older
version (always using ORIGIN) and modified with a newer version (maybe
using REDIRECT or METACOPY, maybe ORIGIN) is not going to work
consistently.

I suspect the proper way out of that is to never use ORIGIN, just do
what we do for directories.  Lookup using dcache isn't going to be all
that much slower than lookup using file handles.   Looking up absolute
redirects may be slower, but I think mass renaming of files is not a
very common use case.

> I am not saying this is not solvable, just that it is more complex
> than the table above and I wouldn't want Vivek to have to untangle
> all this mess with current patch series.
>
> So for compromise, I suggest to follow Vivek's suggestion to
> enforce next_layer == origin_fh if index=on,metacopy=on.
>
> This does not break the copied layer use case, because with
> copied layers, lower layer origin_fh verification on mount will
> fail and won't allow to set index=on.
>
> This is similar to the compromise that we have made with
> nfs_export so we won't need to deal with ovl_fh generations
> when index name does not match origin fh.

Okay, lets do that for now.

Thanks,
Miklos
