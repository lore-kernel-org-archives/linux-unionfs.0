From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2] xfs: publish UUID in struct super_block
Date: Tue, 2 May 2017 17:08:26 +0200
Message-ID: <CAJfpegsZYUHXpzKX+j=-fFzxDPu5jMH=V8MNOOKtRiu5m0Haig@mail.gmail.com>
References: <1493388001-15879-1-git-send-email-amir73il@gmail.com>
 <20170502073019.GD11582@lst.de> <CAOQ4uxjKbgCwhV4iBNVyfmS5+iR3o1BPF+PDj7YmrPP-qTv1eA@mail.gmail.com>
 <20170502141751.GA21564@lst.de> <CAOQ4uxgO64HhFq-xYOY4r1ob_qH1BQbkHyzBSpwmv0WPxX7A1Q@mail.gmail.com>
 <20170502144730.GA22578@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:33615 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750884AbdEBPI2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 2 May 2017 11:08:28 -0400
Received: by mail-io0-f194.google.com with SMTP id o22so6368968iod.0
        for <linux-unionfs@vger.kernel.org>; Tue, 02 May 2017 08:08:27 -0700 (PDT)
In-Reply-To: <20170502144730.GA22578@lst.de>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, May 2, 2017 at 4:47 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Tue, May 02, 2017 at 05:27:36PM +0300, Amir Goldstein wrote:
>> On Tue, May 2, 2017 at 5:17 PM, Christoph Hellwig <hch@lst.de> wrote:
>> > On Tue, May 02, 2017 at 05:13:56PM +0300, Amir Goldstein wrote:
>> >> How can it create problems if uniqueness is not guaranteed with
>> >> Current s_uuid? Even if we did make the xfs uuid table code generic
>> >> It couldn't be the vfs default. Filesystems will have to opt in.
>> >
>> > It creates problems if you e.g. mount an ext4 fs and a dm snaphot of
>> > it.  The non-XFS file systems are simply buggy in this regard.
>> >
>> > Non-uniqueue uuids are an absolute no-go.
>>
>> I'm not sure I follow your specific concern here.
>> Surely you are not proposing to get rid of the nouuid
>> mount option, are you? So what's the point of hiding
>> the fact that there are 2 mounted filesystems with the
>> same uuid from VFS?
>
> Because it breaks people using s_uuid.  Take a look at cleancache,
> which identifies a pool with it.  Once you have to snapshot with
> the same uuid the pool concept is broken.  Same for any sort of
> use in file handles.
>
> The U in UUID stands for unique, and we must ensure that's actually
> true.

Two separate issues:

 a) is s_uuid unique across all currently mounted filesystems on this system
 b) is s_uuid unique for all different filesystems that have been
mounted at one time on some system

We can check (a) but not (b).  But failing (b) could have equally bad
consequences as failing (a).

Thanks,
Miklos
