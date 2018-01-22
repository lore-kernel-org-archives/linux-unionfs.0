From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v10 07/18] ovl: Add mechanism to create a chain of origin dentries
Date: Mon, 22 Jan 2018 21:46:33 +0200
Message-ID: <CAOQ4uxgf0Nh7tQNN=vHmxOQvN8+=ogBjB5HrPs8gDfTeN8eonw@mail.gmail.com>
References: <20180122184004.26026-1-vgoyal@redhat.com> <20180122184004.26026-8-vgoyal@redhat.com>
 <CAOQ4uxiAbz479QygqeJGcbZdO2y1apJo3SqXAXby05c9z2Q85Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f178.google.com ([209.85.213.178]:42688 "EHLO
        mail-yb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbeAVTqf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Jan 2018 14:46:35 -0500
Received: by mail-yb0-f178.google.com with SMTP id i13so3689264ybl.9
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Jan 2018 11:46:34 -0800 (PST)
In-Reply-To: <CAOQ4uxiAbz479QygqeJGcbZdO2y1apJo3SqXAXby05c9z2Q85Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Mon, Jan 22, 2018 at 9:34 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, Jan 22, 2018 at 8:39 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> There is a need to support metacopy dentry in midlayer. That means there
>> could be a chain of metacopy dentries.
>>
>> For example, upper could be metacopy, midlayer lower could be metacopy and
>> lowest layer could be actual data inode. This means when we copy up actual
>> data, we should be able to reach to lowest data inode and copy up data from
>> there. And that means we should keep track of all the dentries in origin
>> chain which lead to data inode.
>>
>> Current ovl_check_origin() logic only looks for one origin dentry. This patch
>> enhances ovl_check_origin() to continue to follow origin chain and return
>> all the origin entries found. This is done only if caller of the function
>> set "follow_chain" argument.
>>
>
> We don't really need to keep the entire chain do we?
> We can follow chain but keep only the one inode that is not a metacopy inode.
> All the rest are useless, no?
> Then we don't create a new type of object - non-dir with numlower > 1.
>

Seems like if you don't keep the entire chain, then no need for
patches 14 and 15.
Also with upper metacopy, you can fix upper origin xattr after
following to the data
origin and forget about middle layer metacopies forever.

Am I missing something?

Thanks,
Amir.
