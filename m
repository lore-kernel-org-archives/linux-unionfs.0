From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 07/12] vfs: do get_write_access() on upper layer of overlayfs
Date: Wed, 19 Oct 2016 11:56:18 +0300
Message-ID: <CAOQ4uxh=AhtZooLL3-g_DjV6zY6mDJWKZsannhLNBt0at3tEYw@mail.gmail.com>
References: <1474028371-21288-1-git-send-email-mszeredi@redhat.com>
 <1474028371-21288-8-git-send-email-mszeredi@redhat.com> <CAOQ4uxju-nD7PLtpPv8yCaN7WHPG9SPM+oaQcthv2ECqJFtKdw@mail.gmail.com>
 <CAJfpegu8dfSzKpvA5g+jPdUXxhuQwNd=TDaH6xDR2ZYt_V6QZQ@mail.gmail.com>
 <CAOQ4uxj5QxcGRMGT78qQf0vmjjP2Do8uaOX-B31HYXt-Wz3Fjg@mail.gmail.com>
 <CAJfpegtDh1xk+bAFqUqS2kbko_BXsV=zhXBx_YfeXnCn_nrjMA@mail.gmail.com> <CAOQ4uxjJJZ9iKXF0K+MQGyem3tUt4Rds5hYhUXNB76bBgZyQvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33737 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942086AbcJSPoC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Oct 2016 11:44:02 -0400
In-Reply-To: <CAOQ4uxjJJZ9iKXF0K+MQGyem3tUt4Rds5hYhUXNB76bBgZyQvQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, "J. Bruce Fields" <bfields@fieldses.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, Oct 19, 2016 at 11:30 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Oct 19, 2016 at 11:12 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Wed, Oct 19, 2016 at 9:41 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>
>>> But I noticed a strange behavior:
>>> When you run t_truncate_self from upper you get success for not being
>>> able to truncate.
>>> When you run t_truncate_self from lower you get an error for being
>>> able to truncate
>>> This is ok as you write, but...
>>> When you re-run t_truncate_self file that just got copied-up you get
>>> segmentation fault
>>> and that is not ok.
>>>
>>> You get try the patch to xfstest below to reproduce the problem:
>>
>> Why would a program want to self truncate itself, except to test denywrite?
>>
>
>
> Forget it. my re-run test was silly. Because the truncate succeeded
> it was trying to run a corrupted executable.
>
> I will send patches to fix the test according to new behavior.

Sent patches to fstests. Please review.

>
> Thanks,
> Amir.
