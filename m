From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Regression in overlayfs in 4.13: "could not fsync file" error by PostgreSQL
Date: Tue, 7 Nov 2017 17:14:41 +0200
Message-ID: <CAOQ4uxh3QsXXYycY9RnOm=46EJ7Oa+4F=mUjGUiC3YeRTQyemQ@mail.gmail.com>
References: <20171103140046.h6oabi5tjqqvj6uj@home.ouaza.com>
 <CAOQ4uxhcWYRcGdwE0QXpZ-_4BFX7LGFyFkFrZSvUgf4PSUFBkg@mail.gmail.com>
 <20171107101125.zwcfd4v3h6pfilhm@home.ouaza.com> <CAOQ4uxhLYovF77D6RpdN1LgQsBLRJsuBK6L_aUdncqPgVeE-mA@mail.gmail.com>
 <1510055685.4518.7.camel@kernel.org> <CAOQ4uxh5GS+hPRZYcQHD5Q+DnibB181_mvZtOnxvvp8tCNPsAg@mail.gmail.com>
 <20171107143237.yvdrpxbbxyimdofy@home.ouaza.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:48973 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933076AbdKGPOn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2017 10:14:43 -0500
Received: by mail-yw0-f193.google.com with SMTP id q1so11149395ywh.5
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Nov 2017 07:14:42 -0800 (PST)
In-Reply-To: <20171107143237.yvdrpxbbxyimdofy@home.ouaza.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Raphael Hertzog <raphael@ouaza.com>
Cc: Jeff Layton <jlayton@kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Nov 7, 2017 at 4:32 PM, Raphael Hertzog <raphael@ouaza.com> wrote:
> Hello,
>
>> Wait, I misread the information in the report and I wrongly assumed that
>> pg_commit_ts is a file. It is not. it's a directory in which case, the
>> inode is an overlay inode and it does have fsync f_op.
>> But in the case of a lower directory that has no been copied up (which seems
>> to be the case with pg_commit_ts) overlayfs will simple vfs_fsync_range the
>> lower dir, so we are back to EINVAL.
>
> Thanks for the explanation, with this understanding I can at least create
> an easy work-around (touch a file in the directory, and drop it again,
> just before starting postgresql).

And you won't be the first to apply that sort of workaround:
http://man7.org/linux/man-pages/man1/yum-ovl.1.html

>
>> > to not have been be copied up here, when it would have before?
>>
>> That is possible, but I would need more information about all the previous
>> access to directory pg_commit_ts by postgresql to figure it out.
>
> FWIW I reported this fsync() on a non-modified directory to PostgreSQL
> developers here:
> https://www.postgresql.org/message-id/20171107135454.lbelbbvfgadljmuj%40home.ouaza.com
>

I guess regardless of what overlayfs behavior should be, PostgreSQL
developers better fix this somehow otherwise postgress upgrade is going to
break for users with stable kernel.

Thanks,
Amir.
