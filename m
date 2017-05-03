From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v4 00/15] overlayfs constant inode numbers
Date: Wed, 3 May 2017 18:46:44 +0300
Message-ID: <CAOQ4uxi4sjY=q4q=kU7vtJEKASUwO9DE3Xa61GMe9wEOHQ-f1g@mail.gmail.com>
References: <1493646126-10101-1-git-send-email-amir73il@gmail.com> <CAJfpegs4SnbHVTa43Wy9R=_3XRMwwnXN9SCKCpq42F-19g9LnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33610 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751858AbdECPqp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 May 2017 11:46:45 -0400
In-Reply-To: <CAJfpegs4SnbHVTa43Wy9R=_3XRMwwnXN9SCKCpq42F-19g9LnQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, May 3, 2017 at 6:43 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, May 1, 2017 at 3:41 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Miklos,
>>
>> This is v4 series of redirect by file handle and constant inode numbers.
>> this series fixes constant inode numbers for stat(2) for overlayfs
>> configuration of all layers on the same fs.
>
> Great work.
>
> I did some mutilation (aka. simplification) and pushed the result to
> overlayfs-constino.v5
>
> No time to check if it works or not, so probably not...  Will do
> tomorrow, but if you have time, please feel free to test and review my
> changes.
>

I will review and test tonight.
Thanks!
