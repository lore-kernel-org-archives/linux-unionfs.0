Received: from mta1.migadu.com (out-6.mta1.migadu.com [95.215.58.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08633EB110
	for <linux-unionfs@vger.kernel.org>; Thu,  3 Sep 2026 09:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788428904; cv=none; b=LWibzu7YvlvZLugLLumoHVsudc4JfFT8rmkD7Uxre+hINkusLUPeYuXDNsxc57qnGi0N1C9striDpaCHQWthG8cYf8XXtfqQTlbsQTW9bbXB1bHXMJxmkB3FYe09GLIskarDFxcX864gM9W0ce9LBXy9AMQTjcsxNJXuyogKVuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788428904; c=relaxed/simple;
	bh=Ik9huR8Fv3jP0fCrZ51BXyUeLfQ8zJYSoZb9a4mFbQ8=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=KrK3BDq9RY8YcUtivSW0IhfpO9h7zNHcJHM6es8sNWReXvmVQ0zlBt92RvpGJPwq/qF+B6GqSy5EJLyAquTDvuEwIlyZje8yDSxrUuSZYl4BJir+7M6b2Oc7CgpDbvbwUkqcfsDTUWLf+TqemlBiELQYOmLreW4YFQVILFHf96Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MLRV92Pw; arc=none smtp.client-ip=95.215.58.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MLRV92Pw"
X-Envelope-To: linux-unionfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Ik9huR8Fv3jP0fCrZ51BXyUeLfQ8zJYSoZb9a4mFbQ8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788428899; v=1; x=1789033699;
 b=MLRV92PwNPHgIaBNkqa+JaiPUhyqm19FLmwYk5EmBIwdO4w4otzGaFtU6bRuRIyiCgM8wTYe
 f1L7PFoRNvBE3k0WbiTKHtWPEGWlqb49wPgnSn036jnPOZiBmgu967MPRl1HOMvBXQimD1wmXqh
 v28olR/t6lbuh21mFn+zw+Po=
X-Envelope-To: linux-unionfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4ed958fe3d1258f7;
	Thu, 03 Sep 2026 09:48:19 +0000
X-Mizu-Trace-ID: 4ed958fe3d1258f7
X-Migadu-Flow: FLOW_OUT
Message-ID: <65de40ce-50bb-495f-8ad8-a396bbaa0a3f@linux.dev>
Date: Thu, 3 Sep 2026 17:48:14 +0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 brauner@kernel.org, jlayton@kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH] overlayfs.rst: document cross-layer file lock and lease
 semantics
To: Amir Goldstein <amir73il@gmail.com>
References: <20260903033359.1042529-1-cui.tao@linux.dev>
 <CAOQ4uxgyPhJQueqUJuwS8=4wGxTAC1Nhy+gfFxrEfaL5A5-EOw@mail.gmail.com>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <CAOQ4uxgyPhJQueqUJuwS8=4wGxTAC1Nhy+gfFxrEfaL5A5-EOw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Amir,

在 2026/9/3 16:34, Amir Goldstein 写道:
> On Thu, Sep 3, 2026 at 5:34 AM Tao Cui <cui.tao@linux.dev> wrote:
>>
>> From: Tao Cui <cuitao@kylinos.cn>
>>
>> Locks and leases taken through an overlay attach to the overlay inode,
>> while opens of the same on-disk file through its real upper/lower path
>> operate on the underlying inode.  The two do not conflict, so an
>> "exclusive" flock/POSIX/OFD lock or a write lease held via the overlay
>> is silently bypassed by anyone reaching the file through the layers
>> directly, e.g. backup tools walking a container's upperdir or another
>> overlay mount over the same layers.
>>
>> Locking through the overlay succeeds and appears to work, so the lack
>> of mutual exclusion only shows up as data corruption when the two
>> sides write concurrently.  Document the semantics, the affected
>> scenarios and the recommended practice.
>>
>> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
>> ---
>>  Documentation/filesystems/overlayfs.rst | 27 +++++++++++++++++++++++++
>>  1 file changed, 27 insertions(+)
>>
>> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
>> index 16c35b491dad..546b77e66016 100644
>> --- a/Documentation/filesystems/overlayfs.rst
>> +++ b/Documentation/filesystems/overlayfs.rst
>> @@ -884,6 +884,33 @@ The "-o userxattr" mount option forces overlayfs to use the
>>  useful for unprivileged mounting of overlayfs.
>>
>>
>> +File locks and leases
>> +---------------------
>> +
>> +File locks (flock, POSIX record locks and OFD locks) and file leases
>> +taken on a file through the overlay attach to the overlay inode.  The
>> +same on-disk file opened through its real upper or lower path is a
>> +different inode object, so locks and leases acquired through one path
>> +do not conflict with locks and leases acquired through the other.
>> +
> 
> Hi Tao,
> 
> Thanks for your contribution, but it is not acceptable as it is.
> 
> Everything written above may be true, but a document needs to be coherent
> and this text was written without regard to the context of the document.
> 
> The most relevant context is:
> 
>   Changes to underlying filesystems
>   ---------------------------------
> 
>   Changes to the underlying filesystems while part of a mounted overlay
>   filesystem are not allowed.  If the underlying filesystem is changed,
>   the behavior of the overlay is undefined, though it will not result in
>   a crash or deadlock.
> 
> TBH I am not enthusiastic about documenting what may happen
> on changes of the underlying layer beyond this statement.
> 
> I am fine with clarifying a bit about the lock scope, but not as much
> as you did -
> keep it to bare minimum which is useful.
> 
> Also when writing text in this document you need to use terminology of
> the document, for example, "same on-disk file" is incoherent with how
> this document refers to underlying layers.
> 
>> +An "exclusive" lock or a write lease held by a task that opened the
>> +file through the overlay does not prevent another task from acquiring
>> +the same lock or opening the file if the latter reaches the file
>> +through the underlying layer directly, e.g.:
>> +
>> +- a tool running outside the container accesses the container's
>> +  upperdir/workdir or the image layers below it directly,
>> +- a second overlay mount is stacked over the same upperdir,
> 
> This is really a disaster setup. I won't even discuss what could go
> wrong with sharing an uperdir
> 
>> +- the same layers are shared between different overlay mounts.
> 
> This is obviously normal so not sure why it is relevant
> 
>> +
>> +Locks and leases do provide mutual exclusion between tasks that all
>> +reach the file through the same overlay mount, and a lease taken
>> +through the overlay is broken by opens through that overlay.
>> +
>> +Do not rely on file locking for mutual exclusion between overlay
>> +users and anything that may touch the underlying layers directly.
>> +
>> +
> 
> These two statements are the only ones that seem relevant to me
> and I would add them in the context of
> "Changes to underlying filesystems" not as a separate section.
> 

Thanks for the review.  Understood - the note belongs in the context
of "Changes to underlying filesystems" and should stay minimal, in
the document's terminology.  I'll follow up with a v2.

Thanks,
Tao

> Thanks,
> Amir.

