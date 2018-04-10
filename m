Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180410140057.GA2776@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com> <20180329193854.13814-21-vgoyal@redhat.com>
 <CAOQ4uxiJpXWXjWMWPa9DGzP06etO7-Y82MKdgroiD08Fhx9H6A@mail.gmail.com> <20180410140057.GA2776@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 10 Apr 2018 22:20:43 +0300
Message-ID: <CAOQ4uxht5LMRpgTDg5AXyTOU4APnQavU-Q2WYpJOnBJNRi3Q4g@mail.gmail.com>
Subject: Re: [PATCH v13 20/28] ovl: Do not set dentry type ORIGIN for broken hardlinks
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Apr 10, 2018 at 5:00 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Mar 30, 2018 at 12:54:14PM +0300, Amir Goldstein wrote:
>> On Thu, Mar 29, 2018 at 10:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > If a dentry has copy up origin, we set flag OVL_PATH_ORIGIN. So far
>> > this decision was easy that we had to check only for oe->numlower
>> > and if it is non-zero, we knew there is copy up origin. (For non-dir
>> > we installed origin dentry in lowerstack[0]).
>> >
>> > But we don't create ORGIN xattr for broken hardlinks (index=off). And
>> > with metacopy feature it is possible that we will still install
>> > lowerstack[0]. But that's lower data dentry of metacopy upper of broken
>> > hardlink and not ORIGIN XATTR is not set.
>> >
>> > So two differentiate between two cases, do not set OVL_PATH_ORIGIN if
>> > we have a broken hardlink.
>> >
>> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> > ---
>> >  fs/overlayfs/util.c | 9 ++++++++-
>> >  1 file changed, 8 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
>> > index 29f7336ade88..961d65bd25c9 100644
>> > --- a/fs/overlayfs/util.c
>> > +++ b/fs/overlayfs/util.c
>> > @@ -117,7 +117,14 @@ enum ovl_path_type ovl_path_type(struct dentry *dentry)
>> >                  * Non-dir dentry can hold lower dentry of its copy up origin.
>>
>> This comment needs updating with metacopy.
>>
>> >                  */
>> >                 if (oe->numlower) {
>> > -                       type |= __OVL_PATH_ORIGIN;
>> > +                       /*
>> > +                        * ORIGIN is created for everyting except broken
>> > +                        * hardlinks
>> > +                        */
>> > +                       if (!(d_inode(dentry)->i_nlink > 1 &&
>> > +                           !ovl_test_flag(OVL_INDEX, d_inode(dentry))))
>> > +                               type |= __OVL_PATH_ORIGIN;
>> > +
>>
>> I don't like relying on overlay nlink. it is not reliable.
>> And I think you missed the directory case.
>
> Directory should be fine because for directories ->i_nlink == 1 and this
> condition will become true.
>
>> The information you need was available during lookup
>> and we did not keep it (was lower verified by origin fh).
>> Most likely what we need to do it store OVL_ORIGIN inode flag
>> during lookup and then use ovl_test_flag(OVL_ORIGIN)
>> in place of OVL_TYPE_ORIGIN(type).
>>
>> If I am not mistaken, you could set flag OVL_ORIGIN in
>> ovl_get_inode() IFF (upperdentry && bylower), but to be honest
>> the rules became so complicated that I can't say for sure.
>> At least I concentrated all the rules in one helper ovl_hash_bylower(),
>> so I hope that helps.
>
> Ok, I can put another ovl-inode flag say OVL_ORIGIN. But that also means
> that I need to set the flag during copy up. And that means it brings
> back ordering requirements for lockless access. For example, in
> ovl_getattr(), if we replace OVL_TYPE_ORIGIN() with ovl_test_flag(ORIGIN),
> without explicit barriers, what's the guarantee a user will see OVL_ORIGIN
> flag yet. In fact it can happen that user might see upperdentry but not
> OVL_ORIGIN.

OK, so instead set OVL_BYLOWER in ovl_get_inode() IFF (bylower).
that property doesn't change on copy up.
and set __OVL_PATH_ORIGIN in ovl_path_type() if upper AND numlower
AND OVL_BYLOWER.

>
> In fact I see OVL_INDEX being used in ovl_getattr(). If a parallel copy
> up took place it is possible that ovl_getattr() saw upperdentry but not
> the OVL_INDEX. And then nlink count will be off. IOW, what barrier/lock
> guarantees that this does not happen.
>

Yes. and that is not the only problem I see with ovl_getattr().

stat->dev could be set to ovl_get_pseudo_dev(dentry), even
if stat->ino is not set to lowerstat.ino; that is not good.

If I am not mistaken, all the special conditions in ovl_getattr()
to use lower st_ino are already encoded in ovl_hash_bylower(),
so you may completely remove those extra tests if
OVL_TYPE_ORIGIN(type) already checks the OVL_BYLOWER
flag.

It may be hard to see my claim above is true, because, for
example, sb->s_export_op in ovl_hash_bylower() is equivalent
to ovl_verify_lower(dentry->d_sb) in ovl_getattr().

Please double check my claims, and if you agree, you can submit a
patch that Fixes: ("a0c5ad307ac0 ovl: relax same fs constraint for
constant st_ino"), which already does the right thing for metacopy.

Thanks,
Amir.
