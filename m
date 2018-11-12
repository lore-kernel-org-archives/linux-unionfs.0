From: Mark Salyzyn <salyzyn@android.com>
Subject: Re: [PATCH v8 2/2] overlayfs: override_creds=off option bypass
 creator_cred
Date: Mon, 12 Nov 2018 10:15:27 -0800
Message-ID: <ad41a028-f0d4-296f-79fd-f00f73f25ce6@android.com>
References: <20181106230117.127616-1-salyzyn@android.com>
 <20181106230117.127616-2-salyzyn@android.com>
 <20181108200106.GB3663@redhat.com>
 <b057da99-adc6-b355-fb57-b314a29f298f@android.com>
 <CAOQ4uxjVPKSaJ2oscvM7jtsDVabnq_qMPg7k4KQEyOLAVPojcg@mail.gmail.com>
 <c6518e90-9429-85a1-fe19-83e058154e2a@android.com>
 <CAOQ4uxgwQAf4NtaE+qhLUTVnvu0ixNZ6Gwotc4q4zR-y35NmZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxgwQAf4NtaE+qhLUTVnvu0ixNZ6Gwotc4q4zR-y35NmZA@mail.gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, "Eric W. Biederman" <ebiederm@xmission.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org, kernel-team@android.com, Paul Lawrence <paullawrence@google.com>, Theodore Tso <tytso@mit.edu>
List-Id: linux-unionfs@vger.kernel.org

On 11/09/2018 11:51 PM, Amir Goldstein wrote:
> On Fri, Nov 9, 2018 at 7:32 PM Mark Salyzyn <salyzyn@android.com> wrote:
>> On 11/08/2018 07:05 PM, Amir Goldstein wrote:
>>> Mark,
>>>
>>> I have some Android internals background, so I have a general
>>> understanding of the
>>> use case, but I can understand why people have a hard time connecting to the
>>> motivation, thinking "their security model must be flawed".
>>>
>>> I am not sure if you are avoiding laying out the details of the model
>>> because you
>>> are not allowed to expose details or because you feel details may confuse us.
>> I am not a "great communicator"(tm), probably only 50K vocabulary,
>> propensity towards quantum leaps, so yes, I was worried about confusion.
>> non-overlapping security model is the key takeaway I feel.
>>
> I hope my comment below will serve as an example why explaining your use
> case is preferred to presenting the abstract and generalized problem.
> And still - no objections to your current patch, *because* it can solve your
> use cases and *because* we don't need to deal with the  abstract and
> generalized problem.
Alas, I personally object to changes to the kernel that have a limited 
(well, 1.8billion devices is not limited) use case. If they can benefit 
others, they become more useful. This paradigm helps prevent spaghetti 
and areas of the kernel that are not well understood and subject to bitrot.
>> [TL;DR]
>>
>> In Android there are two use cases this covers:
>>
>> 1) On userdebug (rooted development) builds, adb remount feature
>>      for readonly filesystems which include squashfs, ext4 dedupe,
>>      and any right-sized (zero space left over) filesystems.  In these cases
>>      the system will resort to utilizing overlayfs, and allow for
>>      updated content to a scratch backing storage.
>> 2) On operating system updates where new Hardware Abstraction
>>      layers have been added and the vendor/oem supplied components
>>      supplied to an older release.  In this corner case the operating
>>      system update may carefully select overrides that are merged into
>>      the vendor partition content directories as hosted by the
>>      operating system partition.
>>
>> The sepolicy model can be browsed at
>> https://android.googlesource.com/platform/system/sepolicy/.
>>
>> In the first use case above the possible insecurity is tempered by the
>> debug nature
>> of the system and the lurking big elephant in the room privilege
>> escalation possibility
>> (/system/bin/su existing),
> Since you already have an elephant in the room, might as well use it
> to mount overlay. I am guessing most of the work in developer mode is
> with sepolicy disabled anyway?
> Essentially, adb root/adb remount means gloves are off.
> Although with overlayed adb remount gloves could be put back on
> when you relinquish the overlay and get back to original /system mount.
adb starts far too late to be useful for the original mount operation. 
We have to mount at init first stage before sepolicy is loaded and init 
is re-exec'd. adb root / adb remount / adb push is relegated to updating 
the content before a reboot to activate _some_ of the possible things 
that developers adjust.

Yes, I find the ability to relinquish the overlayfs and restore the 
system to original an added-value, whereas if we could adjust the 
system&root filesystems directly, a complete reflash is required to 
restore back. We only activate/use the overlayfs for read-only 
system&root filesystems.
>
>> in the other a r/o and precise MAC. sepolicy
>> and credentials
>> will rule over transitions from one security domain to another for
>> execution, vendor components are managed by a separate vendor_init and
>> the actual xattr content is constant.
>>
> For this use case, you don't need an upper layer at all and you probably
> don't use lower layers redirect_dir. Right?
> So all the concerns about get/set trusted overlay xattrs and detecting
> opaque directories (do you need those?) are moot.
> If you propose that override_creds=off can only be enabled
> on lower-only overlayfs, the caveats section of your documentation
> would shrink down considerably to the point that it may even be
> comprehend-able to mortal users and I don't think you will see much
> resistant from overlayfs developers to that "safe side" approach.

Yup, no upper layers. If this was the only uses case, but it isn't.

Besides, I submitted this patch _before_ this second use case presented 
itself as required, it was a later development during the lifetime of 
this patch, so admittedly still focused on the first use case.

I should regroup in the documentation and present the use cases 
individually and specifically ... as you suggest :-) Off to consider a 
v9 respin (KISS documentation has always been troublesome for me) ...

[TL;DR]

The remain snapshot discussion is a distraction, I will have to defer to 
Paul to answer to them (and yes, we have discussed eye-to-eye over this 
and private emails). I agree with the details you have added to the 
conversation.

Sadly the CL in question needs to solve the caveats before we could 
consider overlayfs for userdata.

Thanks for these comments! We should consider when the dust settles.

Sincerely -- Mark Salyzyn
