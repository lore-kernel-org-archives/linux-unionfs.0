From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 10/17] ovl: decode lower file handles of unlinked but
 open files
Date: Wed, 17 Jan 2018 23:05:57 +0200
Message-ID: <CAOQ4uxg6t67uqWK15psBe-a=KD5Wc2DcUy_+1basUhLjXYLyCQ@mail.gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
 <1515086449-26563-11-git-send-email-amir73il@gmail.com> <CAJfpegvbACMv5p3Qb2RhT7dqEucxQmZrJPMiPwp3cbGWKt4h1A@mail.gmail.com>
 <CAOQ4uxjDvxe-h9Ojy44HunqxniOPQBtFO5xoY9NrR3ypOJ5x+Q@mail.gmail.com> <CAJfpegskFBrjED6JmBZbpJ1eLFufmWKbiNV=gDnzCfdj=qaJAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegskFBrjED6JmBZbpJ1eLFufmWKbiNV=gDnzCfdj=qaJAw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

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

If it's all right with you, I prefer to get the initial version out the door
first and handle this optimization later.

Shout if you disagree.

Thanks,
Amir.
