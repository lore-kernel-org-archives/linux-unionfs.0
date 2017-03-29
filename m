From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [REGRESSION 4.11] Commit d8514d8edb5b ("ovl: copy up regular file
 using O_TMPFILE") breaks ubifs
Date: Wed, 29 Mar 2017 22:16:10 +0300
Message-ID: <CAOQ4uxg0xRchsNOh1jtbyEdyDDqV3ToCvo=+QuCsD6duGJU_ZQ@mail.gmail.com>
References: <20170328100107.25095af6@gmail.com> <CAOQ4uxisw5vWYsdMTNemw=MqNyS2nxfAUkg+UfoGmbE3-he1Ug@mail.gmail.com>
 <20170328124545.3c4b87ff@gmail.com> <CAOQ4uxgNfuLN93owdCUJ=9VcU4DKGVEKkEGT7siiem8quVwCsQ@mail.gmail.com>
 <20170328132818.05871b73@gmail.com> <CAOQ4uxiC=RXPwSy7NGt+Ri=Eie4-_WsUPk7Sy-sh9RdrGQuesw@mail.gmail.com>
 <20170328141621.6bb2d639@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:33081 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752944AbdC2TQM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 29 Mar 2017 15:16:12 -0400
In-Reply-To: <20170328141621.6bb2d639@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Ralph Sennhauser <ralph.sennhauser@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org, regressions@leemhuis.info, Richard Weinberger <richard@nod.at>, Artem Bityutskiy <dedekind1@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>

On Tue, Mar 28, 2017 at 3:16 PM, Ralph Sennhauser
<ralph.sennhauser@gmail.com> wrote:
> On Tue, 28 Mar 2017 08:08:51 -0400
> Amir Goldstein <amir73il@gmail.com> wrote:
>
>> On Tue, Mar 28, 2017 at 7:28 AM, Ralph Sennhauser
>> <ralph.sennhauser@gmail.com> wrote:
>> > Hi Amir,
>> >
>> > On Tue, 28 Mar 2017 07:03:11 -0400
>> > Amir Goldstein <amir73il@gmail.com> wrote:
>> >
>> >> Overlayfs now uses O_TMPFILE for copy up and it works fine with all
>> >> the file systems I tested (tmpfs, xfs, ext4).
>> >> If I am right and O_TMPFILE is broken in ubifs, you are most likely
>> >> the first person to test it (indirectly by overlayfs).
>> >>
>> >> Please try to reproduce the bug with following patch to disable
>> >> ubifs O_TMPFILE support:
>> >>
>> >> --- a/fs/ubifs/dir.c
>> >> +++ b/fs/ubifs/dir.c
>> >> @@ -1685,7 +1685,7 @@ const struct inode_operations
>> >> ubifs_dir_inode_operations = {
>> >>  #ifdef CONFIG_UBIFS_ATIME_SUPPORT
>> >>         .update_time = ubifs_update_time,
>> >>  #endif
>> >> -       .tmpfile     = ubifs_tmpfile,
>> >> +       //.tmpfile     = ubifs_tmpfile,
>> >>  };
>> >
>> > Get a unused warning during build but all seems to be working fine
>> > now.
>>
>> OK. I'll wait for ubifs developers to fix the bug.
>> Otherwise, I'll send a proper patch to disable ubifs O_TMPFILE
>> support. Will add tested-by you.
>
> Sounds like a good plan, there is still time for 4.11-rc5. Fine with
> you adding my tested-by in case it will come to this.
>


Ralph,

Can you please try to reproduce the problem with this command
on ubifs:

# create and link a tmpfile - then remove it
sudo rm -rf foo; sudo xfs_io -T -c "flink foo" . ; ls -l foo; sudo rm foo

That's the gist of xfstest generic/004.

You should expect the same behavior of corrupted fs after boot.

This issue should be reproduced since kernel 4.9 when ubifs tmpfile
support was added.

I hope this info can help the ubifs developers fix the problem
independently from overlayfs setup.

Thanks,
Amir.
