From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 05/11] ovl: lookup redirect by file handle
Date: Thu, 27 Apr 2017 09:40:09 +0200
Message-ID: <CAJfpeguFhjAjm6+vqQ8i7nZMKHbm59--biOXA27FMbvYfT4jmw@mail.gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
 <1493025256-27188-6-git-send-email-amir73il@gmail.com> <CAJfpegtz0emDRTHDrq0CrSZXAcovrLAAsX+-WkPGDRbyZD5vOw@mail.gmail.com>
 <CAOQ4uxhu4LVJ-MAjH6McK31MYZ8__RkjCoK31kqJ-7fA2gu+SA@mail.gmail.com>
 <CAOQ4uxiGwd-h2kJVLKkbyBC9YD_a=19ta1HB0F9KueqL_Pr3XA@mail.gmail.com>
 <CAJfpegssdQ4E=uY3bq8zgXLHZsOQaJXpMWtCZ+V=yVM8vmcw5w@mail.gmail.com>
 <CAOQ4uxgPpnnc5dC+PSuOOWdpnobdKZNzgBzmbeW4Lw6P8_--hg@mail.gmail.com>
 <CAJfpeguaePn++tZBvd-2Z68a_8WGfy7EuWLzODyv60E45C6WSQ@mail.gmail.com>
 <CAOQ4uxiozume+xj4KHiDTwqgWmmXKL+6Ksw1EDWXuZYDFa2KVQ@mail.gmail.com>
 <CAJfpegtv4kN4d7ti5f5p=51aQk8U2UT9xdsvZkYoXWOfQ5BNcQ@mail.gmail.com> <CAOQ4uxhi4GReBbBzd8NdCJ+emzMEa1COYAtcaKziMiaZAV96uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxhi4GReBbBzd8NdCJ+emzMEa1COYAtcaKziMiaZAV96uw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Apr 26, 2017 at 4:51 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Apr 26, 2017 at 3:15 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:

>> I don't have good feelings about storing the root fh just because we
>> don't special case the layer root anywhere yet, and I wouldn't want to
>> do that unless there's a good reason.
>>
>
> There are a few reasons for origin.root, not sure if they are good:
> 1. lookup is O(numlower+depth) instead of O(numlower*depth)

We can optimize to O(numlower+depth) even without origin.root.

> 2. origin.uuid validates that we are still on the same sb
>     origin.root validates that we are still using the same lower dirs
>     and that files from old lower were not moved around to find themselves
>     inside a different lower dir

Parent is encoded in the fh, so that makes it resistant to moving. See
the exportfs_get_name() trickery to get a non-dir connected.  It's
needed whether we have origin.root or not.  And yes, it's pretty
heavyweight.   Wondering if it's worth the trouble, since we are not
actually going to use the lower inode for anything else than getting
the inode number.  And then we could just store the inode number
instead of the fh, and be rid of this mess.

If file is moved to another layer by moving an ancestor directory then
we won't detect that.  Question is: do we care?  It's definitely in
the "you messed with lower dirs, you keep the pieces" territory.

> 3. hardlinks between layers (!!!) will still get to the right layer

Even without origin.root it should get the right layer, since we are
encoding the parent in the fh.

> I personally think that reason #1 is the important one, but I think we
> disagree on the technical details of exportfs_decode_fh() and we
> need to sort this out.
>
> Here is my untested implementation of find layer by uuid/rootfh
> with the relevant comments. Maybe it helps you point out what
> I am missing or what you are missing:

Yeah, it simplifies the implementation.  But implementation is
secondary to interface...

Thanks,
Miklos
