From: Mark Salyzyn <salyzyn@android.com>
Subject: Re: [PATCH v14 4/5] overlayfs: internal getxattr operations without
 sepolicy checking
Date: Mon, 4 Nov 2019 13:47:35 -0800
Message-ID: <bc508a5b-13f5-7de3-7146-f17b232df9d5@android.com>
References: <20191022204453.97058-1-salyzyn@android.com>
 <20191022204453.97058-5-salyzyn@android.com>
 <CAOQ4uxgWOmV_x5gRZ9tR+u86GE6JoXn-MSxKkvi87e9owMApZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxgWOmV_x5gRZ9tR+u86GE6JoXn-MSxKkvi87e9owMApZw@mail.gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kernel-team@android.com, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On 10/22/19 11:39 PM, Amir Goldstein wrote:
> On Tue, Oct 22, 2019 at 11:46 PM Mark Salyzyn <salyzyn@android.com> wrote:
>> Check impure, opaque, origin & meta xattr with no sepolicy audit
>> (using __vfs_getxattr) since these operations are internal to
>> overlayfs operations and do not disclose any data.  This became
>> an issue for credential override off since sys_admin would have
>> been required by the caller; whereas would have been inherently
>> present for the creator since it performed the mount.
>>
>> This is a change in operations since we do not check in the new
>> ovl_do_vfs_getxattr function if the credential override is off or
>> not.  Reasoning is that the sepolicy check is unnecessary overhead,
>> especially since the check can be expensive.
>>
>> Because for override credentials off, this affects _everyone_ that
>> underneath performs private xattr calls without the appropriate
>> sepolicy permissions and sys_admin capability.  Providing blanket
>> support for sys_admin would be bad for all possible callers.
>>
>> For the override credentials on, this will affect only the mounter,
>> should it lack sepolicy permissions. Not considered a security
>> problem since mounting by definition has sys_admin capabilities,
>> but sepolicy contexts would still need to be crafted.
>>
> It sounds reasonable to me, but I am not a "security person".
>
>> It should be noted that there is precedence, __vfs_getxattr is used
>> in other filesystems for their own internal trusted xattr management.
>>
> Urgh! "other" filesystems meaning ecryptfs_getxattr()?
> That looks like a loop hole to read any trusted xattr without any
> security checks. Not sure its a good example...

Yes. But it also makes sense since ecryptfs_getxattr is performed inside 
a layer where the security check is done above by the filesystem that 
called it (AFAIK)? This is used by the filesystem, or the security 
layers to pull the actual sepolicy, rather than getting an EPERM and no 
data. The xattr 'data' is needed by the internal layers.

-- Mark
