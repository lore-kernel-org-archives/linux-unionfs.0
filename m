From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 12/23] ovl: store upper/lower real inode in ovl_inode_info
Date: Fri, 16 Jun 2017 14:55:16 +0300
Message-ID: <CAOQ4uxgdJoWcyh7X017pbWiVjHKC+nFDcL4udMeOr4OvANvTLQ@mail.gmail.com>
References: <1497425202-16270-1-git-send-email-amir73il@gmail.com>
 <1497425202-16270-13-git-send-email-amir73il@gmail.com> <CAOQ4uxjn9KQuqrWC6QHRfKXUXqfs75wwijUQWK6QxUv=4yHBKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:34290 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752625AbdFPLzR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 16 Jun 2017 07:55:17 -0400
Received: by mail-ot0-f193.google.com with SMTP id p48so4178782otc.1
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Jun 2017 04:55:17 -0700 (PDT)
In-Reply-To: <CAOQ4uxjn9KQuqrWC6QHRfKXUXqfs75wwijUQWK6QxUv=4yHBKA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Wed, Jun 14, 2017 at 2:00 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Jun 14, 2017 at 10:26 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Introduce ovl_inode_info struct that is embedded in ovl_inode
>> and contains a reference to lowerinode and/or upperinode.
>>
>> Storing the upper/lower real inode in ovl_inode_info replaces
>> the method of storing realinode & ISUPPER flag in vfs inode
>> i_private field.
>>
>> This will be used for hashing overlay inodes before copy up.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>
>> +struct inode *ovl_inode_real(struct inode *inode, bool *is_upper)
>> +{
>> +       struct ovl_inode_info *oi = OVL_I_INFO(inode);
>> +       struct inode *realinode;
>> +
>> +       realinode = READ_ONCE(oi->__upperinode);
>> +       if (!realinode)
>> +               realinode = oi->lowerinode;
>> +       else if (is_upper)
>> +               *is_upper = true;
>
> oops, bug, not setting false (caught by ./run --ov rmdir):
>         if (is_upper)
>                 *is_upper = !realinode;
>

Embarrassing. I fixed the bug in a very buggy way and did not notice that it
broke my tests... should be:

        realinode = READ_ONCE(oi->__upperinode);
        if (is_upper)
                *is_upper = !!realinode;
        if (!realinode)
                realinode = oi->lowerinode;


Pushed the ovl-hardlinks branch with the fixed version.
