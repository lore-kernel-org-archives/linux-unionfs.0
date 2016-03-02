From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: ignore lower entries when checking purity of
 non-directory entries
Date: Wed, 2 Mar 2016 15:15:59 +0100
Message-ID: <CAJfpegu5=CS6muunULWOqso6zdDdrqjSf4jdgieEAbr_un_cvA@mail.gmail.com>
References: <145424627339.27058.6895511767458306300.stgit@zurg>
	<20160201141424.GA1448@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:34946 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbcCBOQB (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 2 Mar 2016 09:16:01 -0500
Received: by mail-ob0-f170.google.com with SMTP id xx9so85906496obc.2
        for <linux-unionfs@vger.kernel.org>; Wed, 02 Mar 2016 06:16:00 -0800 (PST)
In-Reply-To: <20160201141424.GA1448@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, David Howells <dhowells@redhat.com>, Kernel Mailing List <linux-kernel@vger.kernel.org>

On Mon, Feb 1, 2016 at 3:14 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Sun, Jan 31, 2016 at 04:17:53PM +0300, Konstantin Khlebnikov wrote:
>> After rename file dentry still holds reference to lower dentry from
>> previous location. This doesn't matter for data access because data
>> cames from upper dentry. But this stale lower dentry taints dentry
>> at new location and turns it into non-pure upper. Such file leaves
>> visible whiteout entry after remove in directory which shouldn't
>> have whiteouts at all.
>>
>> Overlayfs already tracks pureness of file location in oe->opaque.
>> This patch just uses that for detecting actual path type.
>>
>> Comment from Vivek Goyal's patch:
>>
>> Here are the details of the problem. Do following.
>>
>> $ mkdir upper lower work merged upper/dir/
>> $ touch lower/test
>> $ sudo mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work
>> merged
>> $ mv merged/test merged/dir/
>> $ rm merged/dir/test
>> $ ls -l merged/dir/
>> /usr/bin/ls: cannot access merged/dir/test: No such file or directory
>> total 0
>> c????????? ? ? ? ?            ? test
>>
>> Basic problem seems to be that once a file has been unlinked, a
>> whiteout has been left behind which was not needed and hence it becomes
>> visible.
>>
>> whiteout is visible because parent dir is of not type MERGE, hence
>> od->is_real is set during ovl_dir_open(). And that means ovl_iterate()
>> passes on iterate handling directly to underlying fs. Underlying fs does
>> not know/filter whiteouts so it becomes visible to user.
>>
>> Why did we leave a whiteout to begin with when we should not have.
>> ovl_do_remove() checks for OVL_TYPE_PURE_UPPER() and does not leave
>> whiteout if file is pure upper. In this case file is not found to be
>> pure upper hence whiteout is left.
>>
>> So why file was not PURE_UPPER in this case? I think because dentry is
>> still carrying some leftover state which was valid before rename. For example,
>> od->numlower was set to 1 as it was a lower file. After rename, this state
>> is not valid anymore as there is no such file in lower.
>>
>> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
>> Reported-by: Viktor Stanchev <me@viktorstanchev.com>
>> Diagnosed-by: Vivek Goyal <vgoyal@redhat.com>
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=109611
>
> Hi Konstantin,
>
> Thanks for the patch. This patch works for me also does not break
> unionmount-testsuite.

Thanks for the analysis and patch.  Added to the queue.

Thanks,
Miklos
