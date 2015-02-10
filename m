From: "Caldwell, Blake A." <blakec@ornl.gov>
Subject: Re: Support for filesystems with d_revalidate (NFS)
Date: Tue, 10 Feb 2015 18:26:30 +0000
Message-ID: <C111BFAB-F3C3-49AA-A34E-3E110EC86229@ornl.gov>
References: <E4C1F457-0D8A-4118-9F10-819D8CCA5ADE@ornl.gov>
 <20150209211225.GJ32617@cray.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mta02.ornl.gov ([128.219.177.12]:31369 "EHLO mta02.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375AbbBJS0d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 10 Feb 2015 13:26:33 -0500
In-Reply-To: <20150209211225.GJ32617@cray.com>
Content-Language: en-US
Content-ID: <962DF0289CF4AB44934754066228C2E3@ornl.gov>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eric Jones <ejones@cray.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

Thanks. That could help in the short-term. I'd hope to see see this in mainline eventually. If someone could elaborate on the blanket exclusion of d_revalidate, I'd like to see if the task to add read-only NFS support is reasonable.

-Blake


On Feb 9, 2015, at 2:12 PM, Eric Jones <ejones@cray.com> wrote:

> I don't have an answer, but I'll note it worked at some point. For example, the overlayfs code in SuSE's SLES12 release allows it. I'm not sure why Novell merged such a different version of the overlayfs code.
> 
> 
> On Mon, Feb 09, 2015 at 03:11:46PM +0000, Caldwell, Blake A. wrote:
>> Hi there,
>> 
>> Is perhaps a fix for disabling overlayfsroot for filesystems with revalidate on the horizon? My use case for overlayfs is a NFS (v3 or v4) lowerdir, which appears rejected by the code below because NFS defines d_revalidate, d_automount, and d_weak_revalidate (v3 only).
>> 
>> There has been discussion in this launchpad bug about xattr copyup problems:
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1039402
>> 
>> fs/overlayfs/super.c@692:
>>       /*
>>        * We don't support:
>>        *  - automount filesystems
>>        *  - filesystems with revalidate (FIXME for lower layer)
>>        *  - filesystems with case insensitive names
>>        */
>>       if (dop &&
>>           (dop->d_manage || dop->d_automount ||
>>            dop->d_revalidate || dop->d_weak_revalidate ||
>>            dop->d_compare || dop->d_hash)) {
>>               return false;
>>       }
>> 
>> Regarding the referenced code in overlayfs-next, is there a condition in which NFSv4 could be supported, such as if mounted read-only?
>> 
>> -Blake
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

