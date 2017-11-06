From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v7 5/8] ovl: relax same fs constraint for constant st_ino
Date: Mon, 6 Nov 2017 23:06:23 +0200
Message-ID: <CAOQ4uxju1R0qJST4j8C5HHYW+eCg76BTVYueDh3kyQKA_hsX8w@mail.gmail.com>
References: <1509655091-13630-1-git-send-email-amir73il@gmail.com>
 <1509655091-13630-6-git-send-email-amir73il@gmail.com> <20171106204303.GA23294@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:53112 "EHLO
        mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751745AbdKFVGY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 6 Nov 2017 16:06:24 -0500
Received: by mail-yw0-f176.google.com with SMTP id w2so9062456ywa.9
        for <linux-unionfs@vger.kernel.org>; Mon, 06 Nov 2017 13:06:24 -0800 (PST)
In-Reply-To: <20171106204303.GA23294@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Chandan Rajendra <chandan@linux.vnet.ibm.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Mon, Nov 6, 2017 at 10:43 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Nov 02, 2017 at 10:38:08PM +0200, Amir Goldstein wrote:
>> For the case of all layers not on the same fs, return the copy up origin
>> inode st_dev/st_ino for non-dir from stat(2).
>>
>> This guaranties constant st_dev/st_ino for non-dir across copy up.
>> Like the same fs case, st_ino of non-dir is also persistent.
>>
>> If the st_dev/st_ino for copied up object would have been the same as
>> that of the real underlying lower file, running diff on underlying lower
>> file and overlay copied up file would result in diff reporting that the
>> two files are equal when in fact, they may have different content.
>>
>> Therefore, unlike the same fs case, st_dev is not persistent because it
>> uses the unique anonymous bdev allocated for the lower layer.
>
> I have a stupid question. I thought st_dev is allocated dynamically and
> is not persistent across reboot. Is that not the case? If yes, then
> it is not persistent for same fs case as well. If yes, above does not
> make sense.
>

True. That's a garbage text. Will delete it for v8.
Thanks!
Amir.
