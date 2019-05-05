Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:37136 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725811AbfEELw1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 5 May 2019 07:52:27 -0400
Subject: =?UTF-8?Q?Re=3a_=5bbug_report=5d_chattr_+i_succeed_in_docker_which_?=
 =?UTF-8?Q?don=e2=80=98t_have_the_capability_CAP=5fLINUX=5fIMMUTABLE?=
References: <3393f96c-e9a7-2882-f210-81a9c332a138@linux.alibaba.com>
 <CAOQ4uxgkO23o8yPdeu060oeU6CwhvQs9f+R0qFEiQGLA1SdL6w@mail.gmail.com>
From: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Message-ID: <fd271b51-0d24-41fc-6e31-28c1917479b9@linux.alibaba.com>
Date: Sun, 5 May 2019 19:52:22 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxgkO23o8yPdeu060oeU6CwhvQs9f+R0qFEiQGLA1SdL6w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>



On 2019/5/5 下午6:44, Amir Goldstein wrote:
> On Sun, May 5, 2019 at 12:27 PM Jiufei Xue <jiufei.xue@linux.alibaba.com> wrote:
>>
>> Hi,
>>
>> We are using kernel v4.19.24 and have found that it can be successful
>> when we set IMMUTABLE_FL flag to a file in docker while the docker
>> didn't have the capability CAP_LINUX_IMMUTABLE.
>>
>> # touch tmp
>> # chattr +i tmp
>> # lsattr tmp
>> ----i--------e-- tmp
>>
>> We have tested this case in older version such as 4.9 and it returned
>> -EPERM as expected.
>>
>> We found that the commit d1d04ef8572b ("ovl: stack file ops") and
>> dab5ca8fd9dd ("ovl: add lsattr/chattr support") implemented chattr
>> operations on a regular overlay file. ovl_real_ioctl() overridden the
>> current process's subjective credentials with ofs->creator_cred which
>> have the capability CAP_LINUX_IMMUTABLE so that it will return success
>> in vfs_ioctl()->cap_capable().
>>
>> I wondered is this kind of mechanism of overlayfs or a bug?
>>
> 
> It's a bug, but I am not sure how to fix it.
> If we want to check IMMUTABLE_FL and APPEND_FL permissions
> in ovl_ioctl() we need to execute FS_IOC_GETFLAGS on upper
> file to know if we are changing those flags.
> 
> Note that overlayfs also (never) copied up those flags, so if flags
> exist in lower fs they are lost on copy up.
> Therefore, if we remove ovl_override_creds() from ovl_real_ioctl()
> if lower inode has APPEND_FL it will be removed on copy up
> and chattr +S by user without CAP_LINUX_IMMUTABLE will fail
> because it will do FS_IOC_GETFLAGS from lower and then
> FS_IOC_SETFLAGS that will do copy up and try to set both
> APPEND_FL and SYNC_FL on upper inode.
> 
> Best I can come up with is store flags in overlay inode on
> FS_IOC_GETFLAGS and check changes against stored
> flags on  FS_IOC_SETFLAGS. It relies on the fact that
> chattr always calls FS_IOC_GETFLAGS before it calls
> FS_IOC_SETFLAGS (even with the usage chattr =<flags>).
> 
> Want to try and write a patch and test?
> 

Thanks very much for your detailed explanation. And of course, I want
to try. I will try to send the patch later.

Thanks
Jiufei

> Thanks,
> Amir.
> 
