From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 10/17] ovl: decode lower file handles of unlinked but
 open files
Date: Tue, 16 Jan 2018 12:40:08 +0200
Message-ID: <CAOQ4uxjeesvaciCuj1PY0zM3-CEV46q1bgxx1+98o6UW1NwXvg@mail.gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
 <1515086449-26563-11-git-send-email-amir73il@gmail.com> <CAJfpegvbACMv5p3Qb2RhT7dqEucxQmZrJPMiPwp3cbGWKt4h1A@mail.gmail.com>
 <CAOQ4uxjDvxe-h9Ojy44HunqxniOPQBtFO5xoY9NrR3ypOJ5x+Q@mail.gmail.com> <CAJfpegskFBrjED6JmBZbpJ1eLFufmWKbiNV=gDnzCfdj=qaJAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:39809 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750852AbeAPKkK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 16 Jan 2018 05:40:10 -0500
In-Reply-To: <CAJfpegskFBrjED6JmBZbpJ1eLFufmWKbiNV=gDnzCfdj=qaJAw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Jan 16, 2018 at 12:10 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Jan 16, 2018 at 10:37 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Tue, Jan 16, 2018 at 11:16 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Thu, Jan 4, 2018 at 6:20 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>> Lookup overlay inode in cache by origin inode, so we can decode a file
>>>> handle of an open file even if the index has a whiteout index entry to
>>>> mark this overlay inode was unlinked.
>>>>
>>>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>>>> ---
>>>>  fs/overlayfs/export.c    | 22 ++++++++++++++++++++--
>>>>  fs/overlayfs/inode.c     | 16 ++++++++++++++++
>>>>  fs/overlayfs/overlayfs.h |  1 +
>>>>  3 files changed, 37 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
>>>> index 602bada474ba..6ecb54d4b52c 100644
>>>> --- a/fs/overlayfs/export.c
>>>> +++ b/fs/overlayfs/export.c
>>>> @@ -385,13 +385,21 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
>>>>         struct ovl_path *stack = &origin;
>>>>         struct dentry *dentry = NULL;
>>>>         struct dentry *index = NULL;
>>>> +       struct inode *inode = NULL;
>>>> +       bool is_deleted = false;
>>>>         int err;
>>>>
>>>>         /* First lookup indexed upper by fh */
>>>
>>> Why not first look up origin, then look up ovl inode by origin?  It
>>> seems a faster path than going through the index first.  Obviously if
>>> icache lookup fails then we need to look up index, but the common case
>>> will the cached one, so that should be the fast one, no?
>>>
>>
>> Not really, because we do not know if the file handle is dir or non-dir.
>> If file handle is dir than decode of file handle is expensive and can
>> reduce worst case from two file handle decodes to just one:
>>
>> For lower dir:
>> - one index lookup fails
>> - one lower dir decode
>> - one icache lookup
>> - maybe one ovl_lookup_real(is_upper=false)
>>
>> For copied up indexed dir:
>> - one index lookup success
>> - one upper dir decode
>> - one ovl_lookup_real(is_upper=true)
>>
>> That method avoids the origin dir decode for upper indexed
>> dir at the cost of not looking for the decoded dir in icache.
>>
>> How about this as in idea: hash overlay inodes for NFS export
>> by origin fh instead of by origin inode pointer.
>
> Good idea.  That way we can leave out the middleman (underlying fh
> decode) in the cached case.
>
>> We can also avoid the "lookup index first" for non-dir
>> if we set a flag OVL_FH_FLAG_CONNECTABLE on exported
>> dir file handle, but my thinking was trying to keep the first version
>> simple with as fewer special cases as possible.
>
> Not sure I understand.  If cached lookup fails, then we do always need
> to try and lookup index first before falling back to decoding origin,
> right?
>

If you are referring to cache lookup by origin fh, then yes.
If icache by origin fh lookup fails, we should lookup index to check
for whiteout, before we decode origin fh, because index lookup is
cheaper than reconnecting a connectable file handle decode.

If we had marked the file handle 'non-connectable', then for non-dir
non-connectable file handles, origin decode is actually slightly
faster than index lookup, but I don't think it is worth the special
casing and marking the file handle for the corner case, right?

Thanks,
Amir.
