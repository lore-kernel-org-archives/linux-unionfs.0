From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: overlayfs access checks on underlying layers
Date: Thu, 13 Dec 2018 15:09:55 -0500
Message-ID: <6de7d35e-9ee7-5324-86d0-e0e42c6a6d29@tycho.nsa.gov>
References: <20181204154243.GA16818@redhat.com>
 <665ec6f3-f16d-681f-30d5-eface14c9808@tycho.nsa.gov>
 <20181204161747.GC16818@redhat.com>
 <e8841bf0-d6b8-0e7d-6a35-055a06441d30@tycho.nsa.gov>
 <20181205134317.GA11337@redhat.com>
 <8eb7f677-fd71-c31b-bfed-29fb7187d132@tycho.nsa.gov>
 <20181211214821.GD17242@redhat.com>
 <2e4d90ce-61e7-56b1-c161-4e5fb7236537@tycho.nsa.gov>
 <20181213145813.GB4384@redhat.com>
 <846eb23e-1188-9e45-ee0a-676d26cc715e@tycho.nsa.gov>
 <20181213185456.GC4384@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181213185456.GC4384@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Ondrej Mosnacek <omosnace@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>, Mark Salyzyn <salyzyn@android.com>, Paul Moore <paul@paul-moore.com>, linux-kernel@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org, Daniel J Walsh <dwalsh@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

On 12/13/18 1:54 PM, Vivek Goyal wrote:
> On Thu, Dec 13, 2018 at 11:12:31AM -0500, Stephen Smalley wrote:
> 
> [..]
>>>>> Can you elaborate a bit more on how this is leaking data through overlay
>>>>> mount. If it is, then why accessing file on lower is not equivalent of
>>>>> leaking of data.
>>>>
>>>> In the container use case, retaining the lower label on copy-up for a
>>>> context-mounted overlay permits a process in the container to leak the
>>>> container data out to host files not labeled with the container label and
>>>> thus potentially accessible to other containers or host processes.
>>>
>>>> The
>>>> container process appears to just be writing to files labeled with the
>>>> container label via the overlay, but the written data and/or metadata is
>>>> directly accessible through the lower label, which is likely readable to
>>>> all/many containers and host processes.
>>>>
>>>> In the multi-level security (MLS) use case, an analogy would a situation
>>>> where you have an unclassified lower dir with some content to be shared
>>>> read-only across all levels, and an overlay is context-mounted at each level
>>>> with a corresponding upper dir and work dir private to that level.  If a
>>>> client process at secret performs a write to a file via the secret overlay,
>>>> and if the written data is stored in a file in the upper dir that inherits
>>>> the label from the lower file (unclassified), then the secret process can
>>>> leak data to unclassified processes at will, violating the MLS policy.
>>>
>>> For the case of devices, its already happening. One might change metadata
>>> of a device (hence trigger copy up). Now all writes to upper device file
>>> from secret process still go to same underlying device and are still
>>> readable from lower device file.
>>
>> This is an argument for not copying up device files IMHO, not for preserving
>> the lower label on them.
> 
> How do we handle metadata change to device node (like timestamp, ownership
> change) without copy up.

Do we need to support such metadata changes to device nodes through an 
overlay mount?  Is that required for some legitimate purpose (and if so, 
what is the use case?)?  If not, just deny it up front.  Much simpler 
and no potential for a leak.
