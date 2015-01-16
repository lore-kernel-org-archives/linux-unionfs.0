From: hujianyang <hujianyang@huawei.com>
Subject: Re: [PATCH 3/3] ovl: upper fs should not be R/O
Date: Fri, 16 Jan 2015 10:39:58 +0800
Message-ID: <54B879FE.2060103@huawei.com>
References: <54B74D70.3000205@huawei.com> <54B74E39.8080405@huawei.com>    <8579CCC5-FF7A-42D8-8E5A-381A98DC7CAD@gmail.com> <da4e10d37524bff8ff274a6dbf6170cb.squirrel@www.anemaid>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <da4e10d37524bff8ff274a6dbf6170cb.squirrel@www.anemaid>
Sender: linux-fsdevel-owner@vger.kernel.org
To: jm@mokwan.com
Cc: linux-unionfs@vger.kernel.org, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-Id: linux-unionfs@vger.kernel.org

Hi Alex,

I think your question is about why workdir was introduced. I'd like
to share my thought with you. I should say Miklos is the best candidate
to explain it, because he is the author of this filesystem.

On 2015/1/16 1:09, A. Wan wrote:
> Just one question.  If each r/o layer does not require a workdir, why
> would a stack of r/o layers require one - and hence the requirement that
> the top layer must be r/w?
> 

As far as I know, "workdir" is not belong to any r/o or r/w layer in
overlayfs. Actually it belong to a overlayfs mount itself. "Workdir" is
not mandatory after recently multi-lower layer feature. It is used only
in r/w case, and only valuable in r/w case. My patch wants to make sure
the specified "workdir" in option line is significative.

If you just mount a stack of r/o layers, you don't need any "workdir",
but the mounted overlayfs partition will be marked as r/o. If you want a
r/w mount, you must specify a upperdir, the r/w layer on the top and
specify a workdir in the same mount with upperdir.

Overlayfs is a union filesystem. It gives ability to combine directories
in different mounts together. For r/w mount case, overlayfs allow users
change any file in its mount. But the implement of overlayfs not directly
write to each lower fs. All the write is reflected on the upper layer,
the top r/w layer.

See this link about unionfs:

http://lwn.net/Articles/324291/

"Workdir" works as the temp directory of a overlayfs mount. The file
changing is first done in it and then use rename() move to upper directory.
That's why "workdir" must in the same mount with upperdir.

For example,

if users delete a file which belong to a lower a/o layer in overlayfs
partition, the deletion is not perform on lower fs. Instead, a whiteout
file is created in "workdir" and then move to upperdir.

Other operations, like "copy_up", "rename" also use "workdir" as the
temporary directory. You can read this code in fs/overlayfs yourself.

I think "workdir" is used to keep the consistency of overlayfs and avoid
corrupt data damaging the filesystem. I'd like Miklos could explain more
for us.

> Does it has to do with why workdir was introduced in the first place?

It's not the business of my patch, "workdir" is not introduced by it.
But after rescanning the document in kernel, I think more explanation
about "workdir" is worth to be done.

> Sorry but I couldn't find information about why workdir was introduced.  I
> suppose it was to support some functions that older versions can't.
> 

No, "workdir" is introduced since overlayfs first merged into mainline
and is still needed in r/w mount. But I wonder if there are other
implements instead. Oh, Miklos may be unhappy with my unorthodox notion.

I'm sorry to say I'm not good at English expression, but I'm happy to
clarify any points that are still unclear.

Thanks,
Hu

> Alex
> 
> On Thu, January 15, 2015 12:20 am, Seunghun Lee wrote:
>> On January 15, 2015 2:20:57 PM GMT+09:00, hujianyang
>> <hujianyang@huawei.com> wrote:
>>> After importing multi-lower layer support, users could mount a r/o
>>> partition as the left most lowerdir instead of using it as upperdir.
>>> And a r/o upperdir may cause an error like
>>>
>>> 	overlayfs: failed to create directory ./workdir/work
>>>
>>> during mount.


