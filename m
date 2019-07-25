From: Mark Salyzyn <salyzyn@android.com>
Subject: Re: [PATCH v10 4/5] overlayfs: internal getxattr operations without
 sepolicy checking
Date: Thu, 25 Jul 2019 07:37:07 -0700
Message-ID: <20df8497-17ea-27db-43c8-fcd73633e7f3@android.com>
References: <20190724195719.218307-1-salyzyn@android.com>
 <20190724195719.218307-5-salyzyn@android.com>
 <CAOQ4uxhtASSymEOdh4XByXbxWO2_ZivzqjBrgK7jB3fWXLqr_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxhtASSymEOdh4XByXbxWO2_ZivzqjBrgK7jB3fWXLqr_w@mail.gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kernel-team@android.com, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Thanks for the review.

On 7/25/19 4:00 AM, Amir Goldstein wrote:
> On Wed, Jul 24, 2019 at 10:57 PM Mark Salyzyn <salyzyn@android.com> wrote:
>> Check impure, opaque, origin & meta xattr with no sepolicy audit
>> (using __vfs_getxattr) since these operations are internal to
>> overlayfs operations and do not disclose any data.  This became
>> an issue for credential override off since sys_admin would have
>> been required by the caller; whereas would have been inherently
>> present for the creator since it performed the mount.
>>
>> This is a change in operations since we do not check in the new
>> ovl_vfs_getxattr function if the credential override is off or
>> not.  Reasoning is that the sepolicy check is unnecessary overhead,
>> especially since the check can be expensive.
> I don't know that this reasoning suffice to skip the sepolicy checks
> for overlayfs private xattrs.
> Can't sepolicy be defined to allow get access to trusted.overlay.*?

Because for override credentials off, _everyone_ would need it (at least 
on Android, the sole user AFAIK, and only on userdebug builds, not user 
builds), and if everyone is special, and possibly including the random 
applications we add from the play store, then no one is ...

For the override credentials on, the sepolicy would be required to add 
to init or other mounters so that callers can actually use overlayfs. 
Without the sepolicy for init, overlayfs will not function. the xattr 
are in the backing storage and the details are not exported outside of 
the driver. This would represent an imbalance since none of the callers 
would require the sepolicy adjustment for the ;normal' case, but for 
override credentials off as stated above, _everyone_ would require it.

Not against adding the sepolicy in Android, it is how we roll with only 
opening up credentials on an as-need basis. We could deny it on user 
(customer) builds and that closes a door that gains security. However 
our people are starting to resist userdebug being different from user so 
it may be a door I can not shut. Again felt like an imbalance for a 
trusted driver read only operation.

Sincerely -- Mark Salyzyn
