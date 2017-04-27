From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 05/11] ovl: lookup redirect by file handle
Date: Thu, 27 Apr 2017 11:26:12 +0200
Message-ID: <CAJfpegt9-w_2wQ_Y94w8AcuHYtzJ1fW6n21=eQPbyYqsNawOpQ@mail.gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
 <1493025256-27188-6-git-send-email-amir73il@gmail.com> <CAJfpegtz0emDRTHDrq0CrSZXAcovrLAAsX+-WkPGDRbyZD5vOw@mail.gmail.com>
 <CAOQ4uxhu4LVJ-MAjH6McK31MYZ8__RkjCoK31kqJ-7fA2gu+SA@mail.gmail.com>
 <CAOQ4uxiGwd-h2kJVLKkbyBC9YD_a=19ta1HB0F9KueqL_Pr3XA@mail.gmail.com>
 <CAJfpegssdQ4E=uY3bq8zgXLHZsOQaJXpMWtCZ+V=yVM8vmcw5w@mail.gmail.com>
 <CAOQ4uxgPpnnc5dC+PSuOOWdpnobdKZNzgBzmbeW4Lw6P8_--hg@mail.gmail.com>
 <CAJfpeguaePn++tZBvd-2Z68a_8WGfy7EuWLzODyv60E45C6WSQ@mail.gmail.com>
 <CAOQ4uxiozume+xj4KHiDTwqgWmmXKL+6Ksw1EDWXuZYDFa2KVQ@mail.gmail.com>
 <CAJfpegtv4kN4d7ti5f5p=51aQk8U2UT9xdsvZkYoXWOfQ5BNcQ@mail.gmail.com>
 <CAOQ4uxhi4GReBbBzd8NdCJ+emzMEa1COYAtcaKziMiaZAV96uw@mail.gmail.com>
 <CAOQ4uxiGzp2G3qSC7be3nVnvjYJZuHAmY7Q1Oc+jM+pZWtuHig@mail.gmail.com> <CAJfpegtAx_KXb6v0dBAD0AJvLeTCFF1X4rfdAptn0xPqRHiLBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35890 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032036AbdD0J0O (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2017 05:26:14 -0400
Received: by mail-oi0-f68.google.com with SMTP id a3so5936059oii.3
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2017 02:26:14 -0700 (PDT)
In-Reply-To: <CAJfpegtAx_KXb6v0dBAD0AJvLeTCFF1X4rfdAptn0xPqRHiLBQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Apr 27, 2017 at 9:48 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Apr 27, 2017 at 8:27 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>
>> Let me try to explain the problem with a worse case, but not
>> improbable example:
>>
>> Suppose I have an overlay with deep file at /a/b/c/.../z
>> Suppose the layers are at /old/{lower,upper} I copy them
>> over to /new/{lower,upper} and mount the overlay at new path.
>>
>> Suppose that dcache is fully populated under /new and fully
>> evicted under /old.
>>
>> When trying to decode the file handle for z, exportfs_decode_fh()
>> will call the file system to actually read all directories a..z from disk
>> in order to reconnect the dentry of old z all the way up to /old
>> and it will do that *before* calling the acceptable() callback.
>>
>> Alternatively, if we first try to decode the file handle for /old/lower,
>> decoding will be very fast (most likely already in cache) and we will
>> not have to continue to decoding z and reading all directories a..z
>> from disk.
>
> To answer my own question in the prev mail: we need to decode the fh
> and not just blindly use the inum to prevent issues with
> copied/mutilited/etc lower layers.

Hmm, this is absurd.  Why are we going to all this trouble to find the
origin inode though decoding the file handle when this thing was meant
to be an *optimization*?  Without redirect, we can look up origin just
like we do for merge dirs.  Way faster than decoding a connected
dentry, which is going to result in a readdir of the parent directory
and whatnot.  The only thing we need is a bool "was this copied" flag.

For moved files, decoding the fh might be an optimization over walking
the redirect, but that depends on a various factors, and it might also
be a lot slower...  But it's needed for the snapshot case, right?

Am I missing something?

Thanks,
Miklos
