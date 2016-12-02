From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Overlayfs snapshots pre announce
Date: Fri, 2 Dec 2016 15:34:59 +0100
Message-ID: <CAJfpegtJ7pZNZA3op7iZwCPynYcSCGB6EZ3rZrmdc3zSKucdpA@mail.gmail.com>
References: <CAOQ4uxjXpd_Fy3vBfzcXZYudPoZyXkrLEofLNQ0YPB6HeD9ZgA@mail.gmail.com>
 <CAJfpegsLuy5DjeGEeEs3=RgBkWuku9PSesN1Dk=5pKtS_zHdkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:32822 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755961AbcLBOmo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Dec 2016 09:42:44 -0500
Received: by mail-oi0-f45.google.com with SMTP id w63so268213436oiw.0
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Dec 2016 06:42:44 -0800 (PST)
In-Reply-To: <CAJfpegsLuy5DjeGEeEs3=RgBkWuku9PSesN1Dk=5pKtS_zHdkg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Dec 2, 2016 at 3:05 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, Dec 2, 2016 at 10:30 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Hi Miklos,
>>
>> Wanted to give you a heads up on upcoming announcement for
>> overlayfs snapshots POC, just to give you a sense of what's been
>> driving my recent overlayfs development efforts
>> and also because I am eager to share the news ;-).
>
> Okay, so this is sort of reverse-overlay.  For this to be useful,
> however, there would have to be a way to make the snapshot *after*
> /mnt is mounted, no?

Okay, so doing multiple snapshots on the fly would work something like this:

- there are SNAP{1..N} and a MASTER branch
- view of snapshot(i) is an overlay of (from bottom up) MASTER;
SNAP{N}; ...; SNAP{i}

Modification of master would always go to the latest snapshot branch (SNAP{N}).

The big change to overlayfs is to allow splitting the bottom layer.

Thanks,
Miklos
