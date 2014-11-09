From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 0/7] Security: Provide unioned file support
Date: Sat, 08 Nov 2014 17:31:19 -0800
Message-ID: <545EC3E7.4040002@schaufler-ca.com>
References: <545BC088.6080306@schaufler-ca.com> <545BB147.4000100@schaufler-ca.com> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <6108.1415296719@warthog.procyon.org.uk> <29936.1415373684@warthog.procyon.org.uk> <545D1575.2010708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <545D1575.2010708@redhat.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Daniel J Walsh <dwalsh@redhat.com>, David Howells <dhowells@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
List-Id: linux-unionfs@vger.kernel.org

On 11/7/2014 10:54 AM, Daniel J Walsh wrote:
> On 11/07/2014 10:21 AM, David Howells wrote:
>> Casey Schaufler <casey@schaufler-ca.com> wrote:
>>
>>>>> What does this mean?
>>>> It has been decided that for the purposes of docker, all files within the
>>>> docker root fs will have the same label.  We'd have to provide policy
>>>> namespacing otherwise (I think).
>>> That's just insane. "It has been decided" by who? Obviously not people
>>> who care about security policies. Maybe it's good enough for your
>>> particular use case, but labeling of files has to be up to the security
>>> module. That's what the modules are for.
>> It has been decided by the docker people that I've dealt with.  I was
>> expecting there to be different labels throughout a docker image, but
>> apparently not...
> We want the equivalent of the mount option
> context="system_u:object_r:svirt_sandbox_file_t:s0:c1,c2"

Which just means that the policy used in the container is going
to have to grant access to everything running in that container
to that context. That's fine if you want to emasculate your module
within the container. But it requires that you do so, and that is
wrong.

> Which would label all of the content in the OVERLAYFS with this label. 
> If we have to have a readonly label for the lower
> level and a RW Label for the context mount then that is fine with us. 
> The lower level can actually just reveal the label of the INODE.
> We can take care of labeling it with a single label.
>
> If the context="LABEL" (Or its equivalent is not passed), it should get
> some kind of label based on the parent directory I would guess
> or transition rules. 
>
> With docker we want to treat all contents of a container with a single
> label and then separate containers based on MCS(Svirt) separation.

That seems like a limited and rather pointless use case to me.

>>>>> What about LSMs that have multiple labels on a file?
>>>> Setting policy is something I'll have to leave to the docker people and the
>>>> administrators of systems that use docker.
>>> What does that mean? If the underlying mechanism can't do the job,
>>> how the dickens is the administrator supposed to make it happen?
>> I'm trying to make the kernel able to support a policy on this at all - not
>> actually write the policy itself.  The policy may well vary depending on the
>> installation anyway.
>>
>>>> But all I'm proposing is a way to give the LSM access to both the file in
>>>> the overlay and the file in the lower fs that is leeching through into the
>>>> overlay.
>>> But your mechanisms are simultaneously incomplete and over specified.
>> Well then, specify better ones!  I'm fairly certain it is incomplete and I'm
>> *trying* to get input on how it may be improved.  I should've marked the
>> patches [RFC] but it didn't occur to me until just after I'd sent them (of
>> course).

I'd love to do so, but I'm frying too many kittens right now
to put the effort required into making this right. I do have
faith that this can be worked out. Sorry that I missed the implicit
[RFC]. It helps to know that feedback is still open.

>>
>> Anyway, there are a number of things one has to take account of:
>>
>>  (1) There may be multiple 'views' or instances of a file in a union - and
>>      each may be labelled differently.
>>
>>  (2) The lower file may have xattrs attached to it that represent the security
>>      policy.
>>
>>  (3) The union file may have xattrs attached to it that represent the security
>>      policy.
>>
>>  (4) When copying the lower file up, the xattrs representing the security
>>      attributes of the lower file must not be written as they may incorrectly
>>      overwrite the security attributes of the union file.
>>
>>  (5) There needs to be a way to set the security attributes on the union file.
>>
>>  (6) When setting the attributes on the union file, the LSM might need to take
>>      account of the attributes of the lower file in their derivation.
>>
>>  (7) There may be no inode in the union layer on which to hang the attributes
>>      for the upper file.
>>
>>  (8) struct file::f_security should be used to contain the union layer
>>      labellage on open files that point to a lower layer.
>>
>>  (9) Ideally, file->f_path would point to the union layer and file->f_inode to
>>      the lower layer when there is no upper file.  However, this is not the
>>      case at the moment.  The file struct *only* points to the lower file or
>>      the upper file and never both.
>>
>> (10) Overlayfs has an extra complication in that there are potentially three
>>      files involved in any union.  The lower file that is the source, the
>>      upper file that where the copy-up goes and the virtual union file in the
>>      overlay fs that redirects to one or the other.
>>
>>      I've taken the approach that we assume that the upper file (if it exists)
>>      has the same labellage as the union file.
>>
>>> Your proposal is a cop out. It may work in a limited set of cases.
>>> It is not a general solution.
>> Actually, I think the actual code interface I've proposed is pretty close to
>> being a general solution.  I've given the LSM the information I have, it can
>> implement a fabulous maze of specially crafted labels if it wants to - and
>> even have multiple labels per inode or per file.  The VFS does not care.
>>
>> David
>>
>> _______________________________________________
>> Selinux mailing list
>> Selinux@tycho.nsa.gov
>> To unsubscribe, send email to Selinux-leave@tycho.nsa.gov.
>> To get help, send an email containing "help" to Selinux-request@tycho.nsa.gov.
>

