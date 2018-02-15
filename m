From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH] ovl: check lower ancestry on encode of lower dir
 file handle
Date: Thu, 15 Feb 2018 19:16:26 +0200
Message-ID: <CAOQ4uxgAtSi-OAkAfvBf+RQ0omNM1UtTbuQWPooM8ZJS++y9bw@mail.gmail.com>
References: <1517919700-29182-1-git-send-email-amir73il@gmail.com>
 <1517919700-29182-2-git-send-email-amir73il@gmail.com> <CAJfpegvqnhNiX3Cqux=Pa59TJ40ki5CEBDtjAnRravaTLgDzqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:38003 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1422926AbeBORQ2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 15 Feb 2018 12:16:28 -0500
Received: by mail-yw0-f196.google.com with SMTP id w78so234239ywd.5
        for <linux-unionfs@vger.kernel.org>; Thu, 15 Feb 2018 09:16:27 -0800 (PST)
In-Reply-To: <CAJfpegvqnhNiX3Cqux=Pa59TJ40ki5CEBDtjAnRravaTLgDzqg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Feb 15, 2018 at 6:07 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Feb 6, 2018 at 1:21 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> This change relaxes copy up on encode of merge dir with lower layer > 1
>> and handles the case of encoding a merge dir with lower layer 1, where an
>> ancestor is a non-indexed merge dir. In that case, decode of the lower
>> file handle will not have been possible if the non-indexed ancestor is
>> redirected before or after encode.
>>
>> Before encoding a non-upper directory file handle from real layer N, we
>> need to check if it will be possible to reconnect an overlay dentry from
>> the real lower decoded dentry. This is done by following the overlay
>> ancestry up to a 'layer N connected' ancestor and verifying that all
>> parents along the way are 'layer N connectable'. If an ancestor that is
>> NOT 'layer N connectable' is found, we need to copy up an ancestor, which
>> is 'layer N connectable', thus making that ancestor 'layer N connected'.
>
> Makes sense.  One comment inline, otherwise looks good.
>
>> For example:
>>
>>  layer 1: /a
>>  layer 2: /a/b/c
>>
>> The overlay dentry /a is NOT 'layer 2 connectable', because if dir /a is
>> copied up and renamed, upper dir /a will be indexed by lower dir /a from
>> layer 1. The dir /a from layer 2 will never be indexed, so the alrogithm
>> in ovl_lookup_real_ancestor() (*) will not be able to lookup a connected
>> overlay dentry from the connected lower dentry /a/b/c.
>>
>> To avoid this problem on decode time, we need to copy up an ancestor of
>> /a/b/c, which is 'layer 2 connectable', on encode time. That ancestor is
>> /a/b. After copy up (and index) of /a/b, it will become 'layer 2 connected'
>> and when the time comes to decode the file handle from lower dentry /a/b/c,
>> ovl_lookup_real_ancestor() will find the indexed ancestor /a/b and decoding
>> a connected overlay dentry will be accomplished.
>>
>> (*) the alrogithm in ovl_lookup_real_ancestor() can be improved to lookup
>> an entry /a in the lower layers above layer N and find the indexed dir /a
>> from layer 1. If that improvement is made, then the check for 'layer N
>> connected' will need to verify there are no redirects in lower layers above
>> layer N. In the example above, /a will be 'layer 2 connectable'. However,
>> if layer 2 dir /a is a target of a layer 1 redirect, then /a will NOT be
>> 'layer 2 connectable':
>>
>>  layer 1: /A (redirect = /a)
>>  layer 2: /a/b/c
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>
>> Miklos,
>>
>> I was able to convince myself that this patch is correct and it passed
>> all existing tests and some manual tests of the new cases.
>>
>> I was also able to convince myself that the single CONNECTED bit in dentry
>> is all the optimization we need and that there is no added value in
>> gathering more state information on lookup.
>> This extra lookup information or redirected lower layers will be needed if
>> we ever implement (*) above.
>>
>> Was I able to also convince you that this patch is correct? and that no
>> extra lookup information is needed?
>>
>> I will write more tests to cover the cases handles by this change.
>>
>> Thanks,
>> Amir.
>>
>>  fs/overlayfs/export.c    | 176 +++++++++++++++++++++++++++++++++++++++--------
>>  fs/overlayfs/overlayfs.h |   1 +
>>  2 files changed, 147 insertions(+), 30 deletions(-)
>>
>> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
>> index 07d70255095b..b545e3b8249f 100644
>> --- a/fs/overlayfs/export.c
>> +++ b/fs/overlayfs/export.c
>> @@ -19,6 +19,138 @@
>>  #include <linux/ratelimit.h>
>>  #include "overlayfs.h"
>>
>> +
>> +static int ovl_encode_maybe_copy_up(struct dentry *dentry)
>> +{
>> +       int err;
>> +
>> +       if (ovl_dentry_upper(dentry))
>> +               return 0;
>> +
>> +       err = ovl_want_write(dentry);
>> +       if (!err) {
>> +               err = ovl_copy_up(dentry);
>> +               ovl_drop_write(dentry);
>> +       }
>> +
>> +       if (err) {
>> +               pr_warn_ratelimited("overlayfs: failed to copy up on encode (%pd2, err=%i)\n",
>> +                                   dentry, err);
>> +       }
>> +
>> +       return err;
>> +}
>> +
>> +/*
>> + * Before encoding a non-upper directory file handle from real layer N, we need
>> + * to check if it will be possible to reconnect an overlay dentry from the real
>> + * lower decoded dentry. This is done by following the overlay ancestry up to a
>> + * 'layer N connected' ancestor and verifying that all parents along the way are
>> + * 'layer N connectable'. If an ancestor that is NOT 'layer N connectable' is
>> + * found, we need to copy up an ancestor, which is 'layer N connectable', thus
>> + * making that ancestor 'layer N connected'. For example:
>> + *
>> + * layer 1: /a
>> + * layer 2: /a/b/c
>> + *
>> + * The overlay dentry /a is NOT 'layer 2 connectable', because if dir /a is
>> + * copied up and renamed, upper dir /a will be indexed by lower dir /a from
>> + * layer 1. The dir /a from layer 2 will never be indexed, so the alrogithm (*)
>> + * in ovl_lookup_real_ancestor() will not be able to lookup a connected overlay
>> + * dentry from the connected lower dentry /a/b/c.
>> + *
>> + * To avoid this problem on decode time, we need to copy up an ancestor of
>> + * /a/b/c, which is 'layer 2 connectable', on encode time. That ancestor is
>> + * /a/b. After copy up (and index) of /a/b, it will become 'layer 2 connected'
>> + * and when the time comes to decode the file handle from lower dentry /a/b/c,
>> + * ovl_lookup_real_ancestor() will find the indexed ancestor /a/b and decoding
>> + * a connected overlay dentry will be accomplished.
>> + *
>> + * (*) the alrogithm in ovl_lookup_real_ancestor() can be improved to lookup an
>> + * entry /a in the lower layers above layer N and find the indexed dir /a from
>> + * layer 1. If that improvement is made, then the check for 'layer N connected'
>> + * will need to verify there are no redirects in lower layers above N. In the
>> + * example above, /a will be 'layer 2 connectable'. However, if layer 2 dir /a
>> + * is a target of a layer 1 redirect, then /a will NOT be 'layer 2 connectable':
>> + *
>> + * layer 1: /A (redirect = /a)
>> + * layer 2: /a/b/c
>> + */
>> +static int ovl_dentry_connectable_layer(struct dentry *dentry)
>> +{
>> +       struct ovl_entry *oe = OVL_E(dentry);
>> +
>> +       /* We can get overlay root from root of any layer */
>> +       if (dentry == dentry->d_sb->s_root)
>> +               return oe->numlower;
>> +
>> +       /* We cannot get upper/overlay path from non-indexed lower dentry */
>> +       if (ovl_dentry_upper(dentry) &&
>
> Code is contradicting comment.  I guess code is wrong?
>


This is patch v1, but already posted patch v2 with a bug fix.
patch v2 has a comment above this function:
/* Return 0 for upper file handle, > 0 for lower file handle or < 0 on error. */

N-connectable means you can get from layer <= N to overlay path.
Returning 0 here mean 0-connected, meaning only upper file handle
can be decoded.

What do you find contradicting in code/comment?

>> +           !ovl_test_flag(OVL_INDEX, d_inode(dentry)))
>> +               return 0;
>> +
>> +       /* Pure upper cannot be ancestor of non pure upper */
>> +       if (WARN_ON(!oe->numlower))
>> +               return 0;
>> +
>> +       /* We can get upper/overlay path from indexed/lower dentry */
>> +       return oe->lowerstack[0].layer->idx;
>> +}
>> +

Thanks,
Amir.
