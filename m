From: Jordi Pujol <jordipujolp@gmail.com>
Subject: Re: v4.13 overlay fs: sometimes fails when creating or moving files
Date: Sun, 10 Sep 2017 16:10:04 +0200
Message-ID: <CACTE=gp1JRmVtY_SR4YRx5CsPPFrrPsgbxq=JYH_VYRq8rQZsw@mail.gmail.com>
References: <20170908143704.3c74d20f@localdomain> <CAOQ4uxjC+ONu9nj-BJ8XwuWU0ofq5ySd-YRmXdikQjPAXj3WuA@mail.gmail.com>
 <CACTE=goi1H-rEKA4_2iZTsaW9k9k+kMCgnzWcZJBt4+-M93pmg@mail.gmail.com> <CAOQ4uxhKy1uWarTyAQqXmvk5nPsLYEsb1zgfSaSv-mcxby0+6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:33204 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751704AbdIJOKF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 10 Sep 2017 10:10:05 -0400
Received: by mail-oi0-f54.google.com with SMTP id r20so34793741oie.0
        for <linux-unionfs@vger.kernel.org>; Sun, 10 Sep 2017 07:10:05 -0700 (PDT)
In-Reply-To: <CAOQ4uxhKy1uWarTyAQqXmvk5nPsLYEsb1zgfSaSv-mcxby0+6g@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

This error disappears after installing 4.13.1, but other problems have
arised when unmounting some kind of filesystems.

Maybe it was not an overlayfs error.

On Fri, Sep 8, 2017 at 9:31 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Sep 8, 2017 at 6:55 PM, Jordi Pujol <jordipujolp@gmail.com> wrote:
>>
>> On Fri, 8 Sep 2017 17:20:50 +0300
>> Amir Goldstein <amir73il@gmail.com> wrote:
>>
>> > This sounds a lot like
>> > https://bugzilla.redhat.com/show_bug.cgi?id=1213602 A long standing
>> > issue with a simple workaround (see link above)
>> >
>> the problem also arises when executing
>> touch /var/lib/dpkg/*
>> before upgrading,
>> maybe the issue is not the same,
>>
>> The first time replacing the file does OK, but consecutive replacements fail.
>> Maybe an unitialized variable internally in overlayfs.
>> > Is the problem you are hitting new to v4.13?
>> Yes, this problem is new,
>> therefore my computer continues running 4.12.11 by now.
>>
> I see. Do you see any overlay fs warning in dmesg?
> Please send them as well.
> I did not understand if this happens during file create
> rename delete if you understand the scenario and can send a simple
> reproducer script that would be great.
>
> Thanks,
> Amir.
