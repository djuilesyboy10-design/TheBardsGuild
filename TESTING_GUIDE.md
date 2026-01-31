# TheBardsGuild Framework Testing Guide

## Overview
This guide provides comprehensive testing procedures for all TheBardsGuild framework components. Testing ensures reliability, maintains quality, and validates that our universal systems work correctly across all scenarios.

## Testing Philosophy
- **Manual Testing First** - OpenMW requires in-game validation
- **Structured Approach** - Consistent procedures for all components
- **Documentation as Tests** - Test procedures serve as usage examples
- **Regression Prevention** - Catch issues before they affect users

---

## Universal Trigger System Tests

### 1. NPC Detection Tests

#### BardClass Detection
- [ ] **Trigger fires correctly** when BardClass NPC is within radius
- [ ] **Event sent** with correct payload (NPC name, location, class)
- [ ] **Radius boundaries** work at 150 units
- [ ] **Multiple NPCs** handled correctly
- [ ] **Cell reset** allows trigger to fire again in new cells

#### MerchantClass Detection  
- [ ] **Trigger fires correctly** when "trader service" NPC is within radius
- [ ] **Event sent** with correct merchant data
- [ ] **UI displays** merchant dialogue correctly
- [ ] **Content loads** from merchant_content_data.lua
- [ ] **Menu choices** work as expected

#### PublicanClass Detection
- [ ] **Trigger fires correctly** for tavern NPCs
- [ ] **Event sent** with tavern-specific data
- [ ] **Content displays** appropriate tavern dialogue
- [ ] **Regional variations** work correctly

#### General Detection Tests
- [ ] **No false positives** - triggers don't fire for wrong NPC classes
- [ ] **Performance** - multiple triggers don't cause lag
- [ ] **Concurrent triggers** - multiple NPC types detected simultaneously
- [ ] **Edge cases** - NPCs at exact radius boundary

### 2. Event System Tests

#### Event Firing
- [ ] **Events sent** to correct global/player scripts
- [ ] **Event payload** contains all required data
- [ ] **Event timing** - no delays or missed events
- [ ] **Event sequencing** - correct order for multiple events

#### Event Handling
- [ ] **Event listeners** register and execute correctly
- [ ] **Error handling** - graceful failure on missing handlers
- [ ] **Data integrity** - event data preserved during transmission
- [ ] **Performance** - no event bottlenecks

---

## Plugin Generator Tests

### 1. File Creation Tests

#### Required Files Generated
- [ ] **Helper file** created with correct structure
- [ ] **Event listener file** created with proper event registration
- [ ] **Content data file** created with sample content
- [ ] **README file** generated with usage instructions

#### File Structure Validation
- [ ] **Correct directories** created (Lua/engine/plugins/[class]/)
- [ ] **File naming** follows conventions (snake_case)
- [ ] **File permissions** - files are readable and writable
- [ ] **Duplicate prevention** - no overwriting existing files

#### Code Quality Tests
- [ ] **Syntax validity** - generated code has no syntax errors
- [ ] **Require paths** - correct file references
- [ ] **Function signatures** - match expected interfaces
- [ ] **Code formatting** - follows project standards

### 2. Integration Tests

#### Framework Integration
- [ ] **Generated plugins** register with universal trigger system
- [ ] **Event listeners** respond to trigger events
- [ ] **Content loading** works with generated data files
- [ ] **UI systems** display generated content correctly

#### Customization Tests
- [ ] **Class name parameter** updates all references correctly
- [ ] **Event name parameter** updates trigger configuration
- [ ] **Radius parameter** affects detection behavior
- [ ] **Content templates** customize appropriately

---

## Universal Activator Framework Tests (Future)

### 1. Container Activators

#### Herbalism Pattern
- [ ] **Container activation** triggers herbalism system
- [ ] **Skill progression** works correctly
- [ ] **Event flow** from activation to skill update
- [ ] **Content validation** - correct flora types detected

#### General Container Tests
- [ ] **Multiple container types** supported
- [ ] **Conditional activation** based on skills/items
- [ ] **Event chaining** - activators trigger other events
- [ ] **Performance** - no lag with many containers

### 2. Object Activators

#### Interactive Objects
- [ ] **Object activation** triggers correct responses
- [ ] **Visual feedback** - appropriate animations/effects
- [ ] **State persistence** - objects remember activation state
- [ ] **Multiple interactions** - complex object behaviors

### 3. Door Activators

#### Conditional Entry
- [ ] **Door requirements** - keys, skills, quests checked
- [ ] **Event firing** - door events sent correctly
- [ ] **Lock state** - persistent across sessions
- [ ] **Security systems** - multiple condition checks

---

## Performance Tests

### 1. System Performance

#### Trigger System
- [ ] **Detection efficiency** - no performance impact with many NPCs
- [ ] **Event throughput** - handle multiple simultaneous events
- [ ] **Memory usage** - no memory leaks over extended play
- [ ] **Cell transitions** - smooth performance when changing cells

#### Plugin System
- [ ] **Loading time** - plugins load quickly on game start
- [ ] **Memory footprint** - reasonable memory usage per plugin
- [ ] **Event handling** - efficient event processing
- [ ] **UI responsiveness** - no lag in dialogue systems

### 2. Stress Tests

#### High-Volume Scenarios
- [ ] **Many NPCs** - 20+ NPCs in area with triggers active
- [ ] **Rapid activations** - quick successive interactions
- [ ] **Large content** - extensive dialogue/content files
- [ ] **Extended sessions** - hours of continuous play

---

## Regression Tests

### 1. Core Functionality

#### Existing Systems
- [ ] **Merchant system** continues working after framework changes
- [ ] **Bard system** remains functional after updates
- [ ] **Universal triggers** work across all framework versions
- [ ] **Plugin generation** produces consistent output

#### Cross-System Integration
- [ ] **Multiple plugins** work together without conflicts
- [ ] **Event system** handles multiple event types
- [ ] **UI systems** display content from different sources
- [ ] **Save system** persists all framework data correctly

---

## User Experience Tests

### 1. Gameplay Validation

#### In-Game Testing
- [ ] **Natural interactions** - systems feel integrated, not intrusive
- [ ] **Performance** - no noticeable lag or stuttering
- [ ] **Reliability** - systems work consistently across sessions
- [ ] **Intuitiveness** - interactions make sense to players

#### Content Quality
- [ ] **Dialogue displays** correctly formatted and readable
- [ ] **Menu navigation** works smoothly and intuitively
- [ ] **Visual feedback** - appropriate responses to player actions
- [ ] **Error handling** - graceful failures don't break immersion

### 2. Developer Experience

#### Framework Usage
- [ ] **Clear documentation** - developers understand how to use systems
- [ ] **Easy integration** - new plugins can be created quickly
- [ ] **Debugging support** - helpful error messages and logging
- [ ] **Extensibility** - framework supports custom enhancements

---

## Testing Procedures

### 1. Pre-Development Testing
- Verify baseline functionality exists
- Document current system behavior
- Identify known issues and limitations
- Establish performance benchmarks

### 2. Development Testing
- Test each component as it's developed
- Validate integration with existing systems
- Check performance impact of changes
- Update documentation with test results

### 3. Pre-Release Testing
- Comprehensive system validation
- Performance testing under load
- User experience validation
- Documentation completeness check

### 4. Post-Release Testing
- Monitor for regression issues
- Collect user feedback and bug reports
- Validate fixes don't introduce new issues
- Update test procedures based on findings

---

## Test Documentation

### 1. Test Results Recording
- Document all test outcomes
- Note any failures or issues
- Record performance metrics
- Track regression test results

### 2. Issue Tracking
- Log all discovered bugs
- Prioritize fixes based on impact
- Track resolution progress
- Validate fixes don't introduce new issues

### 3. Test Evolution
- Update tests as systems evolve
- Add new test cases for new features
- Retire obsolete tests
- Improve test procedures based on experience

---

## Testing Tools and Utilities

### 1. Debug Logging
- Enable detailed logging for test sessions
- Capture event flow and system state
- Record performance metrics
- Document error conditions

### 2. Test Scenarios
- Create save games for specific test conditions
- Develop test characters with appropriate skills/items
- Set up controlled environments for testing
- Document test scenario requirements

### 3. Validation Scripts
- Create Lua scripts for automated validation
- Develop test data generators
- Build performance monitoring tools
- Establish result comparison utilities

---

## 🚨 Critical Development Rules

### **Folder Structure Rules (CRITICAL - Never Break!)**
- **`Lua/` folder** = Working/Development folder ONLY
- **`scripts/` folder** = Production/Deployment folder ONLY  
- **NEVER register `Lua/` paths** in `TheBardsGuild.omwscripts`
- **ALWAYS use `scripts/` paths** for script registration

### **Development Workflow:**
1. **Work in `Lua/` folder** - Safe development environment
2. **Test and validate** - Ensure files work correctly
3. **Copy to `scripts/` folder** - Only when ready for production
4. **Register in `TheBardsGuild.omwscripts`** - Use `scripts/` paths only

### **Quick Reference:**
- **Development:** `Lua/` (working folder)
- **Production:** `scripts/` (deployment folder)
- **Registration:** Always `scripts/`

*See `FOLDER_STRUCTURE_RULES.md` for complete documentation*

---

## Success Criteria

### 1. Functional Success
- All systems work as designed
- No critical bugs or crashes
- Performance meets requirements
- User experience is smooth and intuitive

### 2. Quality Success
- Code follows project standards
- Documentation is complete and accurate
- Tests provide meaningful validation
- Systems are maintainable and extensible

### 3. Community Success
- Frameworks are easy for others to use
- Documentation enables self-service development
- Examples demonstrate best practices
- Community can extend and enhance systems

---

## Conclusion

This testing guide ensures TheBardsGuild frameworks maintain high quality, reliability, and usability. By following these procedures consistently, we can build systems that serve both our immediate needs and the broader modding community.

Remember: Testing isn't just about finding bugs - it's about validating that our systems work as intended and provide the foundation for amazing user experiences.
