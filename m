Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180503143359.GA10792@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com> <20180426191013.13219-10-vgoyal@redhat.com>
 <CAOQ4uxg5xDZJVuys69QtGBRGcs3=zfkJQoZgTZRp+cG+GGVzEQ@mail.gmail.com>
 <20180430140243.GB7960@redhat.com> <CAOQ4uximhvDrOn6s-5X-BeGvfG0RtTBU-WA6fEjfyYEkn4jvNw@mail.gmail.com>
 <20180502190957.GB2800@redhat.com> <20180502194042.GC2800@redhat.com>
 <CAOQ4uxhOBS_7QWy6Spz0gd3B+bCm7vAh7tfiRBC9hqOaWBENmQ@mail.gmail.com> <20180503143359.GA10792@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 3 May 2018 23:05:47 +0300
Message-ID: <CAOQ4uxhnSWQz=DazY7WfX71mrgezLw3rGhT0q4=n8=nLUUa1Lg@mail.gmail.com>
Subject: Re: [PATCH v14 09/31] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

[...]
>>
>> Besides that I am still worried about corners we missed in setup of
>> metacopy=on,index=off.
>>
>> I may be confused about whether lower with nlink=1 with index=off
>> after metacopy up uses upper st_ino and hashed by upper inode?
>> Need to understand whether the "hashed by" state is consistent with
>> metacopy=on,index=off in all cases.
>
> metacopy=on, index=off should not change inode number reporting. For
> the case of nlink=1 and index=off, st_ino of lower is reported and
> metacopy=on/off does not matter at all. Similarly, ovl_hash_bylower()
> remains untouched due to metacopy. So for the case of nlink=1, index=off,
> inode should still be hashed using lower inode number.
>
> Only thing metacopy feature changes in stat() is st_blocks. It should
> not impact st_ino or st_dev reporting at all.
>

I did not articulate my concern correctly. The problem is not with
index=off, but with !ovl_can_decode_fh() which implies index=off,
but does not imply metacopy=off.

With !ovl_can_decode_fh(), lower cannot be followed by ORIGIN
and therefore cannot have CONST_INO, but with METACOPY
lower is followed... only until METACOPY xattr is removed and
then lower is no longer followed.

The solution is probably to fix (or at least audit) ovl_hash_bylower()
to recognize this case and treat those lowers as broken hardlinks
even though they have nlink=1, so METACOPY won't hash by lower
and won't use lower st_ino.
As I wrote, I am not sure there are problems here, but would like
to make sure that there aren't any problems.

Thanks,
Amir.
