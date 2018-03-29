Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180328194349.GA3966@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com> <20180306205408.23383-10-vgoyal@redhat.com>
 <CAOQ4uxgMO6pMQh2tb4tVpQgXDoG7pwOFjo=uGL_BkAYW20ZrHQ@mail.gmail.com>
 <20180307132128.GA5350@redhat.com> <CAOQ4uxha9Qopz7uieXLNYpr87v+UDJUVrWWzaQ0VGuHWYDn0QQ@mail.gmail.com>
 <20180328194349.GA3966@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 29 Mar 2018 07:27:52 +0300
Message-ID: <CAOQ4uxgP8Ct+ngJ-oaJZOVvrjBYP-3P9u3JOGy2KMJodQoYccA@mail.gmail.com>
Subject: Re: [PATCH v12 09/17] ovl: Do not mark a non dir as _OVL_PATH_MERGE
 in ovl_path_type()
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Mar 28, 2018 at 10:43 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Mar 07, 2018 at 03:37:10PM +0200, Amir Goldstein wrote:
>> On Wed, Mar 7, 2018 at 3:21 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > On Wed, Mar 07, 2018 at 09:07:22AM +0200, Amir Goldstein wrote:
>> >> On Tue, Mar 6, 2018 at 10:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> >> > With the addition of an origin chain for regular files, it is possible
>> >> > that we don't have an upperdentry and oe->numlower > 1 for non-dir. So
>> >> > mark a path __OVL_TYPE_MERGE only if it is a directory.
>> >> >
>> >>
>> >> Okay, but what's wrong with marking a non-dir as TYPE MERGE?
>> >> It is, after all, a sort of merged entry.
>> >
>> > Conceptually, I can't think of anything wrong. Just that currently we use
>> > MERGE in the context of directory and we don't need it in the context of
>> > non-dir. So this is just trying to be safe to make sure not to break any
>> > existing code.
>> >
>> > I guess we could mark metacopy regular files as MERGE as well, if need be.
>> > But that could be part of a separate patch series where we could run
>> > various tests and make sure nothing is broken.
>> >
>>
>> I did a quick scan on all uses of OVL_TYPE_MERGE() they
>> all have is_dir check in front of them or checked on a parent object.
>>
>> In fact, in the case of ovl_rename(), for directory, the test is
>>    if (ovl_type_merge_or_lower(old))
>>       err = ovl_set_redirect(old, samedir);
>>
>>
>> You could have removed the is_dir condition before this code instead
>> of adding a different case for is_metacopy, although you did use a different
>> argument for samedir in the metacopy case...
>
> Hi Amir,
>
> I am looking into merging code path for dir and non-dir. What I can't
> understand is that why do we check for "ovl_type_merge_or_lower()" and
> not just "ovl_type_merge()"?
>
> By now, "old" dentry has been copied up anyway. So no point is checking
> if this is lower or not? It will always be "upper"?
>
> What am I missing?
>

I don;t think you are not missing anything.
Maybe its a relic from the past.
Only the use of ovl_type_merge_or_lower() in ovl_can_move() is really
needed.

Thanks,
Amir.
