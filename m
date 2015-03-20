From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: d_path() and overlay fs
Date: Fri, 20 Mar 2015 19:16:17 +0100
Message-ID: <CAJfpegtLj44fTAAUvQqBafD51WMHMMq6xxjF819fFftzM8Peog@mail.gmail.com>
References: <20150320132914.GA1749@ws.net.home>
	<CA+5PVA6P3cEy9L+PngXdkVki=x32jZmtPJ2b5oT6SLL=U1NAnw@mail.gmail.com>
	<20150320160123.GE20913@tucsk>
	<20150320162558.GA29656@ZenIV.linux.org.uk>
	<20150320165352.GF20913@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:33692 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbbCTSQS (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 20 Mar 2015 14:16:18 -0400
Received: by qcbjx9 with SMTP id jx9so61525907qcb.0
        for <linux-unionfs@vger.kernel.org>; Fri, 20 Mar 2015 11:16:17 -0700 (PDT)
In-Reply-To: <20150320165352.GF20913@tucsk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Karel Zak <kzak@redhat.com>, David Howells <dhowells@redhat.com>, Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Mar 20, 2015 at 5:53 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, Mar 20, 2015 at 04:25:58PM +0000, Al Viro wrote:
>> On Fri, Mar 20, 2015 at 05:01:23PM +0100, Miklos Szeredi wrote:
>>
>> > But it does take care of the majority of f_path users that actually want the
>> > covering path.
>>
>> Bloody bad idea, IMO.  I have no objections against adding _helpers_ from
>> that patch (seq_file_path(), etc.), but I really don't like adding that
>> second struct path there.  And it still doesn't fix the issue with
>> LSM, etc., so we'll _still_ need to fix it sane way.
>
> Obviously getting rid of the extra path would be good.  But we still have lots
> of f_path.dentry in filesystems and we need to start with that.

So we'd need the following helpers:

file_path() - d_path() but gets file
seq_file_path() - seq_path() but gets file
f_covering_path() - other uses of ->f_path that don't want the backing
filesystem's dentry
file_dentry() - uses of f_path.dentry that want the backing filesystem's dentry
file_mount() - uses of f_path.mnt

Hopefully that would cover all f_path uses.

I'd really not want to keep f_path with that name, because it would
just breed new f_path.dentry uses in filesystems.  Better no direct
f_path references at all.

Thanks,
Miklos
