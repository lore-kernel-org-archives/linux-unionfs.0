Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8B2478869;
	Fri,  9 Oct 2026 07:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791531542; cv=none; b=c8I4gHeMMIXJlZTxmy9T77CCqGxAA6qxIoa2gmpjDrwjs+jPvFOdJStzf/5gFS4ABKQ2OiR+AdKxEBsk8jdHAReu+YplOVDQiSCN9vpRakFyHHUQUXE+j1IZlcUFZ1bLs+xI2XuB/dpAX03v6VK/ep0LxdWliR24PTDT+h4X5f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791531542; c=relaxed/simple;
	bh=YS/G4dj1HW/Yb2KstDU9WJAmPRI04c2PPyVXUhF0UJU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=mwvWuPflh+mWsxfI0IXECGCx4OyHI7bUEg3LfoKrU826POiEffapHx70VnjhCXy8nAGhetfisOcGKkQCDOOLRVi5K8V7V5cdivCJWYm6noSrPsFvtTHNpZOnjGosWjGMVqZAC2ETCk+7J/kEZjkjweyQ06wJgrpkv5NBxTqynW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ieqp3pX1; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ieqp3pX1"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6993ad5d3063328;
	Fri, 9 Oct 2026 07:38:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=5Sxs1E
	QwFeXeXB1CiEHrISbo2bz6yugCbmjnoVMkcI4=; b=Ieqp3pX10uxzUQ4Mvm5xP/
	Sov92prJo5DGa6hjsYuOxm5kP6WCXbx+Y3m0tMO60N7vZPwz/g34ysV3WsOUaU1z
	ZG7MRZrOaqslQyYTFpVQDlJmC9sIHsVAxMKTrWijowgB7mUoNBgAjqGzjPJxBag4
	izF5F8jEJAOPgWTbvzZEBJKesvVOQTYsyUw8+v9zgzj96Am/ve4fT445w9ijjeuX
	tDwJjXHz1tGDi7bN6Ygqhs9lAxv9ruEr16zF5w4epxyCkhUlut/0XfTTqgQOOWuJ
	KL+fnswAez2ZDioNfb41MGrcc1REAEnhjylLUofw0AOgcNfSPuKR1AYuxtqe8g/A
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h5xjw8j2k-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 09 Oct 2026 07:38:52 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6996s4u7464301;
	Fri, 9 Oct 2026 07:38:52 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h6udd04n7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 Oct 2026 07:38:52 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6997coBR47907296
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 9 Oct 2026 07:38:50 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0DD332004F;
	Fri,  9 Oct 2026 07:38:50 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 263152004B;
	Fri,  9 Oct 2026 07:38:47 +0000 (GMT)
Received: from [9.124.218.17] (unknown [9.124.218.17])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  9 Oct 2026 07:38:46 +0000 (GMT)
Message-ID: <a7c90513-4821-4519-83ba-77d5f38f6e43@linux.ibm.com>
Date: Fri, 9 Oct 2026 13:08:45 +0530
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ovl: fix wrong layer paths in mountinfo for detached
 mount FDs
From: Disha Goel <disgoel@linux.ibm.com>
To: Amir Goldstein <amir73il@gmail.com>, brauner@kernel.org
Cc: miklos@szeredi.hu, viro@zeniv.linux.org.uk, jack@suse.cz, shuah@kernel.org,
        linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20260924112858.51392-1-disgoel@linux.ibm.com>
 <20260924112858.51392-2-disgoel@linux.ibm.com>
 <CAOQ4uxgj3RL2roivmha9yeWToR-s9kaBm8WUK1vJ_q7pWOjxOQ@mail.gmail.com>
 <95790639-84d0-4cc2-92a8-c97c920b2d22@linux.ibm.com>
Content-Language: en-GB
In-Reply-To: <95790639-84d0-4cc2-92a8-c97c920b2d22@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDAzMCBTYWx0ZWRfX7/LKLhDGvmFx
 KEWXn104MZ2x892qcVB65fnrSgQSfXuMj9YJq4VNcb22sHCaHP7Uiu3sAL29ZZ28SE4s3Wjg2It
 NQgRFysV4hI6ZnRHKqSnYS1zn7tdMpU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDAzMCBTYWx0ZWRfX4k5TkVyTPaUj
 QuoH1EHvX9VcyQPOevtLgKO7Z/nB0Ig7xt1fw/RkDmMw4J2YOTJ/BbO8zLqN4TH++MfSh2T2MlO
 flbNp+jTKJDK7z9rb/zw/OOZ8V9qTiWYXREzJTto0/+caGur14sY9QQc/zxjAveXVeQkWnVIV4g
 fipjXNBGLsUmB1ye0DhFp7icpcmStk2xG9RH5N3Ja25UHYzTmhNAwkO32V4V+eXSQY7FtTXcMRR
 H2WwRqg7Z0ovL1m5VEKZmV/gF9NRXYi87DJNetZb6owBcLhQSzksxyLFbRdT6sUNLW/1uovs5+Y
 ThnhHs8JUhOJ8KUENbpvLxW+FEuk7o988zWiu79khCeJ+sQn0Czdb4aEF6PqBNXeSC8wJJjYfeu
 i5i7iLfWTaVu8a3L46GkprUPCwKMAcslAXSP7DsQGlM+4oPIcG/9CAD7Gb1Hv9Zb325FGxeztUa
 3+2gtDa6KBaCrWTxy8A==
X-Proofpoint-GUID: -3TLmIH8EOVeZWh1b2gj-ZnbVV8FnVBC
X-Proofpoint-ORIG-GUID: TuZKQ98qX3yQVWsfzrlbQkOsSjZ0o6P5
X-Authority-Analysis: v=2.4 cv=XcwcX455 c=1 sm=1 tr=0 ts=6ac89a0d cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=oG8368zUV8cp1tqYUBAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_02,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610020000
 definitions=main-2610090030

Hi Christian,

Looking for your suggestion on this patch series before we come to a
conclusion or send a v2.

On 28/09/26 12:52 pm, Disha Goel wrote:
> On 25/09/26 9:27 pm, Amir Goldstein wrote:
>> On Thu, Sep 24, 2026 at 1:29 PM Disha Goel <disgoel@linux.ibm.com> wrote:
>>>
>>> When overlayfs layers are passed as detached mount file descriptors
>>> (opened with open_tree(OPEN_TREE_CLONE)), ovl_parse_layer() uses 
>>> d_path()
>>> to record the layer's path for display in mountinfo.
>>>
>>> d_path() walks up the mount tree to the process's filesystem root.  For
>>> detached mounts this walk stops at the anonymous namespace root instead
>>> of the real system root, producing a short incorrect path like "/l1"
>>> instead of the full absolute path.
>>>
>>> Export mnt_is_anon() from fs/namespace.c to detect detached mounts.  In
>>> ovl_parse_layer(), use dentry_path_raw() for detached mounts instead of
>>> d_path().  dentry_path_raw() walks the dentry chain independent of mount
>>> namespace and returns the correct fs-relative path.  The path is
>>> display-only; the actual layer_path used for mounting is always correct.
>>>
>>> Also fix the set_layers_via_detached_mount_fds selftest: the mountinfo
>>> check strings were copy-pasted from the regular (non-detached) test and
>>> expected absolute /tmp/ paths, causing the test to always fail.
>>>
>>> Fixes: a08557d19ef4 ("ovl: specify layers via file descriptors")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
>>
>> Disha,
>>
>> Thanks for the report!
>>
>>> ---
>>>   fs/namespace.c                                |  9 ++++++++
>>>   fs/overlayfs/params.c                         | 14 ++++++++++-
>>>   include/linux/mount.h                         |  1 +
>>>   .../overlayfs/set_layers_via_fds.c            | 23 +++++++++++--------
>>>   4 files changed, 37 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/fs/namespace.c b/fs/namespace.c
>>> index ae5dc64f8b45..9feefa0a517d 100644
>>> --- a/fs/namespace.c
>>> +++ b/fs/namespace.c
>>> @@ -363,6 +363,15 @@ bool __mnt_is_readonly(const struct vfsmount *mnt)
>>>   }
>>>   EXPORT_SYMBOL_GPL(__mnt_is_readonly);
>>>
>>> +bool mnt_is_anon(struct vfsmount *mnt)
>>> +{
>>> +       struct mount *m = real_mount(mnt);
>>> +       struct mnt_namespace *ns = READ_ONCE(m->mnt_ns);
>>> +
>>> +       return !IS_ERR_OR_NULL(ns) && is_anon_ns(ns);
>>> +}
>>> +EXPORT_SYMBOL_GPL(mnt_is_anon);
>>> +
>>>   static inline void mnt_inc_writers(struct mount *mnt)
>>>   {
>>>   #ifdef CONFIG_SMP
>>> diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
>>> index c93fcaa45d4a..2758ff8426b7 100644
>>> --- a/fs/overlayfs/params.c
>>> +++ b/fs/overlayfs/params.c
>>> @@ -477,7 +477,19 @@ static int ovl_parse_layer(struct fs_context 
>>> *fc, struct fs_parameter *param,
>>>                  layer_path = param->file->f_path;
>>>                  path_get(&layer_path);
>>>
>>> -               layer_name = d_path(&layer_path, buf, PATH_MAX);
>>> +               /*
>>> +                * For detached mounts (open_tree(OPEN_TREE_CLONE)), 
>>> d_path()
>>> +                * resolves against the anonymous namespace root and 
>>> returns a
>>> +                * short fs-relative path rather than a full system 
>>> path.  Use
>>> +                * dentry_path_raw() instead, which gives the path 
>>> relative to
>>> +                * the filesystem root regardless of mount 
>>> namespace.  The name
>>> +                * is display-only; layer_path itself is always correct.
>>> +                */
>>> +               if (mnt_is_anon(layer_path.mnt))
>>> +                       layer_name = dentry_path_raw(layer_path.dentry,
>>> +                                                    buf, PATH_MAX);
>>> +               else
>>> +                       layer_name = d_path(&layer_path, buf, PATH_MAX);
>>>                  if (IS_ERR(layer_name))
>>>                          return PTR_ERR(layer_name);
>>>
>>> diff --git a/include/linux/mount.h b/include/linux/mount.h
>>> index acfe7ef86a1b..51e9f228c9d1 100644
>>> --- a/include/linux/mount.h
>>> +++ b/include/linux/mount.h
>>> @@ -78,6 +78,7 @@ extern void mnt_make_shortterm(struct vfsmount *mnt);
>>>   extern struct vfsmount *mnt_clone_internal(const struct path *path);
>>>   extern bool __mnt_is_readonly(const struct vfsmount *mnt);
>>>   extern bool mnt_may_suid(struct vfsmount *mnt);
>>> +extern bool mnt_is_anon(struct vfsmount *mnt);
>>>
>>>   extern struct vfsmount *clone_private_mount(const struct path *path);
>>>   int mnt_get_write_access(struct vfsmount *mnt);
>>> diff --git a/tools/testing/selftests/filesystems/overlayfs/ 
>>> set_layers_via_fds.c b/tools/testing/selftests/filesystems/overlayfs/ 
>>> set_layers_via_fds.c
>>> index 7a293544233d..12d930fe46be 100644
>>> --- a/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
>>> +++ b/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
>>> @@ -686,23 +686,28 @@ TEST_F(set_layers_via_fds, 
>>> set_layers_via_detached_mount_fds)
>>>          while (getline(&line, &len, f_mountinfo) != -1) {
>>>                  char *haystack = line;
>>>
>>> -               if (strstr(haystack, "workdir=/tmp/w"))
>>> +               /*
>>> +                * Detached mount FDs are resolved via 
>>> dentry_path_raw(),
>>> +                * which gives a path relative to the underlying fs root
>>> +                * (e.g. "/u/upper", "/l1") rather than a full system 
>>> path.
>>> +                */
>>> +               if (strstr(haystack, "upperdir=/u/upper"))
>>>                          layers_found[0] = true;
>>> -               if (strstr(haystack, "upperdir=/tmp/u"))
>>> +               if (strstr(haystack, "workdir=/u/work"))
>>>                          layers_found[1] = true;
>>> -               if (strstr(haystack, "lowerdir+=/tmp/l1"))
>>> +               if (strstr(haystack, "lowerdir+=/l1"))
>>>                          layers_found[2] = true;
>>> -               if (strstr(haystack, "lowerdir+=/tmp/l2"))
>>> +               if (strstr(haystack, "lowerdir+=/l2"))
>>>                          layers_found[3] = true;
>>> -               if (strstr(haystack, "lowerdir+=/tmp/l3"))
>>> +               if (strstr(haystack, "lowerdir+=/l3"))
>>>                          layers_found[4] = true;
>>> -               if (strstr(haystack, "lowerdir+=/tmp/l4"))
>>> +               if (strstr(haystack, "lowerdir+=/l4"))
>>>                          layers_found[5] = true;
>>> -               if (strstr(haystack, "datadir+=/tmp/d1"))
>>> +               if (strstr(haystack, "datadir+=/d1"))
>>>                          layers_found[6] = true;
>>> -               if (strstr(haystack, "datadir+=/tmp/d2"))
>>> +               if (strstr(haystack, "datadir+=/d2"))
>>>                          layers_found[7] = true;
>>> -               if (strstr(haystack, "datadir+=/tmp/d3"))
>>> +               if (strstr(haystack, "datadir+=/d3"))
>>>                          layers_found[8] = true;
>>>          }
>>>          free(line);
>>> -- 
>>> 2.45.1
>>>
>>
>> Christian,
>>
>> I confirm that the test is failing on upstream:
>>
>> # Starting 1 tests from 1 test cases.
>> #  RUN           set_layers_via_fds.set_layers_via_detached_mount_fds ...
>> # set_layers_via_fds.c:717:set_layers_via_detached_mount_fds:Expected
>> layers_found[i] (0) == true (1)
>> # set_layers_via_fds.c:39:set_layers_via_detached_mount_fds:Expected
>> rmdir("/set_layers_via_fds") (-1) == 0 (0)
>> # set_layers_via_detached_mount_fds: Test terminated by assertion
>> #          FAIL  set_layers_via_fds.set_layers_via_detached_mount_fds
>> not ok 1 set_layers_via_fds.set_layers_via_detached_mount_fds
>> # FAILED: 0 / 1 tests passed.
>>
>> I could not find a point of regression.
>> Could it be that the test was merged failing?
>> That would be strange.
>>
>> This is how mountinfo of detached layers look like on upstream:
>> / /set_layers_via_fds rw,relatime - overlay none
>> rw,lowerdir+=/,lowerdir+=/,lowerdir+=/,lowerdir+=/,datadir+=/,datadir+=/,datadir+=/,upperdir=/upper,workdir=/work,uuid=on,metacopy=on
>>
> 
> Hi Amir,
> 
> Thanks for looking into this!
> 
> On my ppc64le system (7.3.0-rc4) I saw dentry_path_raw() giving per-
> directory names like lowerdir+=/l1, upperdir=/u/upper etc., which is why
> I went with the kernel fix. But your observation of lowerdir+=/ for all
> layers is a valid outcome too depending on how d_path() terminates.
> 
> You are right that the test strings (/tmp/l1 etc.) never matched
> detached mount output.
> 
>> Whether the suggested solution is what we want for it, I am not sure.
>> I also don't recall if we discussed this at the time and whether
>> there were any decisions about how to present this mountinfo.
>>
>> Maybe this mountinfo is fine and then we only need to fix the test.
> 
> Happy to send a v2 with just the selftest fix if that is the preferred
> direction.
> 
>> Thanks,
>> Amir.
> 

-- 
Regards,
Disha

