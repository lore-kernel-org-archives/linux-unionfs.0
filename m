Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180430193201.GC7960@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com> <20180426191013.13219-10-vgoyal@redhat.com>
 <CAOQ4uxg5xDZJVuys69QtGBRGcs3=zfkJQoZgTZRp+cG+GGVzEQ@mail.gmail.com> <20180430193201.GC7960@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 30 Apr 2018 23:21:21 +0300
Message-ID: <CAOQ4uxipF0bZsR5ho-440ejT0wB5eqsfe2WL8wDAh4xArzCtrQ@mail.gmail.com>
Subject: Re: [PATCH v14 09/31] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Apr 30, 2018 at 10:32 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Sat, Apr 28, 2018 at 01:14:24AM -0700, Amir Goldstein wrote:
>
> [..]
>> > @@ -836,6 +836,15 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
>> >         if (index)
>> >                 ovl_set_flag(OVL_INDEX, inode);
>> >
>> > +       if (upperdentry) {
>> > +               err = ovl_check_metacopy_xattr(upperdentry);
>> > +               if (err < 0)
>> > +                       goto out_err;
>> > +               metacopy = err;
>> > +               if (!metacopy)
>> > +                       ovl_set_flag(OVL_UPPERDATA, inode);
>> > +       }
>> > +
>>
>> There is no reason to ovl_check_metacopy_xattr again here, right?
>> so it should get the same treatment as upperredirect.
>> This would make 3 new arguments to ovl_get_inode added by your patch set.
>>
>> How about initializing this struct during lookup and passing it into
>> ovl_get_inode()?:
>
> How about just creating another structure to pass in parameters to
> ovl_get_inode() and then let it extract relevant info and initialize
> inode.  Something like this.

Its definitely better than current state of affairs.

Thanks,
Amir.
