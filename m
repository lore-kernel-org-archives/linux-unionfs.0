Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3223C2775;
	Wed, 12 Aug 2026 21:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786568696; cv=none; b=MbXviuGANZSdz2A1dAPPj926DaRFm7QxqHpPVySnfOCnxSOu0TJdsgosfMQsmEl9AwYk0wQqIgZAwbmFK/UOPKc+IFdpIdiQrUXpVTjgTmhcVvZS/rsBrkp3csCbb90lw5D2dW9P9wqctO4W5krR+pk79kEzd3BedE/3XySaPX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786568696; c=relaxed/simple;
	bh=bx/okdXyR7RcFk1AUbYPefFJ5iiqzEAFVMOrm9vLPHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=YYbRrUXfsygtuhNhaDVzYV0bj9oUaFAYD7rVuRxeLXKaGV09nwVTUFp35Ec6N3/ysvdELg1pPVy7sCtIxD3yyd9tlnqdwrTixdokXFREoVDBrmxIiXJH+0/4hqAaPtElyw92Zq0wFl2JJNSJOL/xmQ3G1RBm9tGRwpfFg6nywLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=M6nTTmRi; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="M6nTTmRi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1786568691; x=1787173491; i=quwenruo.btrfs@gmx.com;
	bh=roDWoDW8YwY+KpehBBvcbQmUep2Bzb3QaqkQXlWhUSM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=M6nTTmRiTONQKRuy+Tn86Jm1pnbSfMWPGnMGKbC+RViM2xrhX3DlgUmMADEMVTTx
	 eo8qqbuY2oPrbF0mIxVyUDxZU3sQ8KfK67MIVeG2slKyAB2fpLAbINpQQ+oVUGOG4
	 3Ql9ctGUfxNhd3yxiEFbSE4rYrWfheEUHtnl9wvWFQIA0Wb8omExS784kkAAJr8Ss
	 s+M60UJoqyFt7ocgymIe0CevPBk1tl+xeYf6hqrLg6tHimtFXGISawgq9RzfYEK7m
	 aXVoTMHWwPuoJQPbjECojPd/FPFQg44bdeeyqpaOS+x2lAlz0u8qZEcOePUd8cegQ
	 T1Lb/XQdfU5GkkyImg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MryT9-1xFJ3e0IYn-00lzr3; Wed, 12
 Aug 2026 23:04:51 +0200
Message-ID: <d543c7a0-f094-4f01-a206-3b37bd704157@gmx.com>
Date: Thu, 13 Aug 2026 06:34:46 +0930
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] src/vfs: probe O_TMPFILE support on the base mount in
 the idmapped tests
To: Christian Brauner <brauner@kernel.org>, Miklos Szeredi
 <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
 linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 fstests@vger.kernel.org
References: <20260615-overlay-idmapped-vfstest-v1-0-c6b3b2228092@kernel.org>
 <20260615-overlay-idmapped-vfstest-v1-1-c6b3b2228092@kernel.org>
 <fbfbafef-2b42-4f5e-ac8e-9c680a0be5ad@gmx.com>
 <anyWAp6UjfojZtAL@zlang-mailbox>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <anyWAp6UjfojZtAL@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:YKWUoyFKudZKvZiyQzFHXWI5n1VrT9cR3sIXfuOm8PMqp29+fFl
 DWMZ4y+FRZOLkivCH+UQFa5d2octZPNLCSP5cQdbAMF2369sDm1DNntGflaxNFdmMku1W5V
 3UX/rDqMELNfPO0keL5UbGEcZv1i0KnnVlIxd1Dh+kyBLY14rxci9A1HnJoBBYU9ENuMQA2
 fi1QHCRwgZvhxqc1d1JmA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:tymV+noFebU=;PQ0EMR+NpSb/rmjFSlMFzjkJui5
 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



=E5=9C=A8 2026/8/13 01:26, Zorro Lang =E5=86=99=E9=81=93:
> On Mon, Jul 20, 2026 at 06:15:31PM +0930, Qu Wenruo wrote:
>>
>>
>> =E5=9C=A8 2026/6/16 01:03, Christian Brauner =E5=86=99=E9=81=93:
>>> openat_tmpfile_supported() in the idmapped mount tests probes O_TMPFIL=
E
>>> on the idmapped mount (open_tree_fd) as the test's fsuid -- but that
>>> fsuid is not mapped by the idmapped mount under test, so it really ask=
s
>>> "can this unmapped caller create a tmpfile through this idmap?" instea=
d
>>> of "does the filesystem support O_TMPFILE?".
>>>
>>> On overlayfs this is a false negative: the backing tmpfile ends up own=
ed
>>> by an unmapped id, overlayfs opens it with O_NOATIME and may_open()
>>> returns -EPERM, so the tmpfile sub-tests are wrongly skipped.
>>>
>>> O_TMPFILE support is a property of the filesystem, not of the idmapped
>>> mount or the caller's mapping. Probe info->t_dir1_fd, the base mount
>>> that the caller owns, exactly as the non-idmapped setgid tests already
>>> do. The probe then succeeds on every filesystem and the tmpfile
>>> sub-tests run as the mapped fsuid.
>>>
>>> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
>>
>> Reviewed-by: Qu Wenruo <wqu@suse.com>
>>
>> Furthermore, since kernel commit 539dce114465 ("fs: refuse O_TMPFILE
>> creation with an unmapped fsuid or fsgid"), even without overlayfs the
>> involved tests will fail due to the extra checks.
>>
>> So this is not only affecting overlayfs but all regular fses now.
>>
>> I hope we can at least merge this one asap.
>=20
> Hi Wenruo,
>=20
> Before merging this patch, I've merged your:
>    commit 1cca2bc0d7a9462bb1b59edb108bac7c9e7c424d
>    Author: Qu Wenruo <wqu@suse.com>
>    Date:   Fri Jul 17 16:37:17 2026 +0930
>=20
>        fstests: vfstest: skip rejected tmpfile creation
>=20
> Since (Christian's) patch seems to replace yours (I think), so do you mi=
nd
> if I revert your patch and merge this one instead?

Yes, please. That's exactly what I expect.

Thanks,
Qu

>=20
> Thanks,
> Zorro
>=20
>>
>> Thanks,
>> Qu
>>
>>> ---
>>>    src/vfs/idmapped-mounts.c | 12 ++++++------
>>>    1 file changed, 6 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/src/vfs/idmapped-mounts.c b/src/vfs/idmapped-mounts.c
>>> index ed9992f9..8f8441c9 100644
>>> --- a/src/vfs/idmapped-mounts.c
>>> +++ b/src/vfs/idmapped-mounts.c
>>> @@ -3838,7 +3838,7 @@ int tcore_setgid_create_idmapped(const struct vf=
stest_info *info)
>>>    		goto out;
>>>    	}
>>> -	supported =3D openat_tmpfile_supported(open_tree_fd);
>>> +	supported =3D openat_tmpfile_supported(info->t_dir1_fd);
>>>    	pid =3D fork();
>>>    	if (pid < 0) {
>>> @@ -4014,7 +4014,7 @@ int tcore_setgid_create_idmapped_in_userns(const=
 struct vfstest_info *info)
>>>    		goto out;
>>>    	}
>>> -	supported =3D openat_tmpfile_supported(open_tree_fd);
>>> +	supported =3D openat_tmpfile_supported(info->t_dir1_fd);
>>>    	pid =3D fork();
>>>    	if (pid < 0) {
>>> @@ -7733,7 +7733,7 @@ static int setgid_create_umask_idmapped(const st=
ruct vfstest_info *info)
>>>    		goto out;
>>>    	}
>>> -	supported =3D openat_tmpfile_supported(open_tree_fd);
>>> +	supported =3D openat_tmpfile_supported(info->t_dir1_fd);
>>>    	pid =3D fork();
>>>    	if (pid < 0) {
>>> @@ -7947,7 +7947,7 @@ static int setgid_create_umask_idmapped_in_usern=
s(const struct vfstest_info *inf
>>>    		goto out;
>>>    	}
>>> -	supported =3D openat_tmpfile_supported(open_tree_fd);
>>> +	supported =3D openat_tmpfile_supported(info->t_dir1_fd);
>>>    	/*
>>>    	 * Below we verify that setgid inheritance for a newly created fil=
e or
>>> @@ -8181,7 +8181,7 @@ static int setgid_create_acl_idmapped(const stru=
ct vfstest_info *info)
>>>    		goto out;
>>>    	}
>>> -	supported =3D openat_tmpfile_supported(open_tree_fd);
>>> +	supported =3D openat_tmpfile_supported(info->t_dir1_fd);
>>>    	pid =3D fork();
>>>    	if (pid < 0) {
>>> @@ -8536,7 +8536,7 @@ static int setgid_create_acl_idmapped_in_userns(=
const struct vfstest_info *info)
>>>    		goto out;
>>>    	}
>>> -	supported =3D openat_tmpfile_supported(open_tree_fd);
>>> +	supported =3D openat_tmpfile_supported(info->t_dir1_fd);
>>>    	/*
>>>    	 * Below we verify that setgid inheritance for a newly created fil=
e or
>>>
>>

